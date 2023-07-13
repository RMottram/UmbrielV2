//
//  TheVaultView.swift
//  Umbriel
//
//  Created by Ryan Mottram on 06/07/2023.
//

import SwiftUI
import CoreData
import LocalAuthentication

struct TheVaultView: View {
    
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Vault.title, ascending: true)]) var vault: FetchedResults<Vault>
    
    @State private var showAddView:Bool = false
    @State private var searchText = ""
    @State private var isUnlocked = false
    @State private var noBiometrics = false
    @State private var isBiometricSupported = false
    @State private var biometricType = LABiometryType.none
    @State private var isDeleteAll = false
    
    var body: some View {
        
        ZStack {
            
            if isUnlocked {
                
                NavigationView {
                    
                    VStack {
                        
                        // MARK: Search Bar
                        VStack {
                            SearchBar(text: $searchText)
                                .padding(.top, 10)
                            HStack {
                                if self.vault.count == 1 {
                                    Text("\(vault.count) entry")
                                        .font(.system(.caption, design: .rounded))
                                        .foregroundColor(.secondary).fontWeight(.light)
                                        .padding(.leading, 12)
                                } else {
                                    Text("\(vault.count) entries")
                                        .font(.system(.caption, design: .rounded))
                                        .foregroundColor(.secondary).fontWeight(.light)
                                        .padding(.leading, 12)
                                }
                                Spacer()
                            }
                        }
                        
                        // MARK: Password Entries List
                        if vault.count == 0 {
                            Text("No entries found, press the \(Image(systemName: "plus")) button to create a new entry").foregroundColor(.secondary)
                                .font(.system(.title, design: .rounded)).multilineTextAlignment(.center).padding(.horizontal, 20).padding(.top, 20)
                            Spacer()
                        } else {
                            List {
                                ForEach(self.vault.filter({ searchText.isEmpty ? true : $0.description.contains(searchText) })) { passwords in
                                    NavigationLink(destination: EditVaultEntryView(password: passwords)) {
                                        EntryRow(passwordEntry: passwords)
                                    }
                                }.onDelete(perform: self.removePasswordEntry)
                            }
                            .onTapGesture {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
                        }
                    }
                    
                    // MARK: NavBar Items
                    .navigationTitle("TheVault")
                    .navigationBarItems(leading: EditButton(), trailing:
                                            HStack {
                        Button(action: {
                            isDeleteAll.toggle()
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.weakColour)
                        }
                        .offset(x: -20)
                        Button(action: {
                            showAddView.toggle()
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                        .sheet(isPresented: $showAddView) {
                            AddNewPasswordView()
                        })
                }
                .alert(isPresented: $isDeleteAll) {
                    Alert(
                        title: Text("Delete All"),
                        message: Text("Are you sure you want to delete all? This cannot be undone!"),
                        primaryButton: .cancel(Text("Cancel")),
                        secondaryButton: .destructive(Text("Delete All"), action: {
                            DataController().deleteAllEntries(context: managedObjContext)
                    }))
                }
                .onDisappear(perform: lockVault)
            } else {
                
                VStack {
                    Spacer()
                    
                    Image(systemName: "lock.shield")
                        .font(.system(size: 100))
                    
                    Text("TheVault requires the use of your devices' TouchID or FaceID sensors to be used. If these have not been activated please activate them in your devices settings.")
                        .multilineTextAlignment(.center)
                        .padding(.all, 10)
                        .font(.system(.body, design: .rounded))
                        .minimumScaleFactor(0.5)
                    
                    Spacer()
                    
                    if isBiometricSupported {
                        Button(action: {
                            authenticate()
                        }) {
                            Text(biometricType == .faceID ? "Unlock with FaceID" : "Unlock with TouchID")
                                .font(.system(size: 20, design: .rounded))
                        }
                        .frame(minWidth: 0, maxWidth: UIScreen.main.bounds.width/1.2)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.init(red: 58/255, green: 146/255, blue: 236/255))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                    
                    Spacer()
                    
                }
                
            }
        }
        .onAppear {
            checkBiometricSupport()
            authenticate()
        }
        
    }
    
    private func getRecordsCount() -> Int {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Vault")
        var counter = 0
        do {
            counter = try managedObjContext.count(for: fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        return counter
    }
    
    private func removePasswordEntry(offsets: IndexSet) {
        withAnimation {
            offsets.map { vault[$0] }.forEach(managedObjContext.delete)
            DataController().save(context: managedObjContext)
        }
    }
    
    private func checkBiometricSupport() {
        let context = LAContext()
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            isBiometricSupported = true
            biometricType = context.biometryType
        }
    }
    
    private func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate to enter TheVault"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                
                isBiometricSupported = true
                biometricType = context.biometryType
                
                DispatchQueue.main.async {
                    if success {
                        self.isUnlocked = true
                    }
                    else {
                        // error
                    }
                }
            }
        } else {
            // no biometrics
            self.noBiometrics = true
        }
    }
    
    private func lockVault() {
        isUnlocked = false
    }
    
    // MARK: Vault EntryRowView
    struct EntryRow: View {
        
        var passwordEntry: Vault
        @State private var isHidden: Bool = true
        
        var body: some View {
            
            HStack {
                VStack(alignment: .leading) {
                    Text(passwordEntry.title ?? "No title given").font(.system(.body, design: .rounded)).bold()
                        .padding(.vertical, 10)
                }
            }
        }
    }
}

// MARK: Vault SearchBarView
struct SearchBar: View {
    @Binding var text: String
    
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            
            TextField("", text: $text)
                .font(.system(.body, design: .rounded))
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if isEditing {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                            .transition(AnyTransition.opacity.animation(.easeIn(duration: 0.2)))
                        }
                    }
                )
                .padding(.horizontal, 10)
                .onTapGesture {
                    withAnimation {
                        self.isEditing = true
                    }
                }
            
            if isEditing {
                Button(action: {
                    withAnimation {
                        self.isEditing = false
                    }
                    self.text = ""
                    
                    // dismiss keyboard
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    
                }) {
                    Text("Cancel")
                        .font(.system(.body, design: .rounded))
                }
                .padding(.trailing, 10)
                .transition(AnyTransition.move(edge: .trailing))
                .animation(.easeIn(duration: 0.2))
            }
        }
    }
}

struct TheVaultView_Previews: PreviewProvider {
    static var previews: some View {
        TheVaultView()
    }
}
