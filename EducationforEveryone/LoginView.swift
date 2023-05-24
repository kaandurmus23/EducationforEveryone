import SwiftUI
import Firebase

struct ContentView: View {
    var body: some View {
        NavigationView {
            LoginView()
        }
    }
}

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isRegistering = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            VStack {
                Text("Üye Girişi/Kaydol")
                    .font(.largeTitle)
                    .padding()
                
                TextField("Email", text: $email)
                    .padding()
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .keyboardType(.emailAddress)
                
                SecureField("Şifre", text: $password)
                    .padding()
                
                Button("Giriş Yap") {
                    login()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                NavigationLink(destination: RegisterView()) {
                    Text("Kayıt Ol")
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(10)
                }
                
                Spacer()
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Hata"), message: Text(alertMessage), dismissButton: .default(Text("Tamam")))
            }
        }
    }
    
    private func login() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                let errorMessage = error.localizedDescription
                alertMessage = "Giriş yaparken bir hata oluştu: \(errorMessage)"
                showAlert = true
            } else {
                // Login successful, navigate to the main screen
                redirectToMainView(firebaseuid: (authResult?.user.uid)!)
            }
        }
    }
    
    private func redirectToMainView(firebaseuid: String) {
        let mainView = MainView(firebaseuid: firebaseuid)
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UIHostingController(rootView: mainView)
            window.makeKeyAndVisible()
        }
    }
}

struct RegisterView: View {
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    let db = Firestore.firestore()
    
    var body: some View {
        VStack {
            Text("Kayıt Ol")
                .font(.largeTitle)
                .padding()
            
            TextField("Kullanıcı Adı", text: $username)
                .padding()
            
            TextField("Email", text: $email)
                .padding()
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .keyboardType(.emailAddress)
            
            SecureField("Şifre", text: $password)
                .padding()
            
            Button("Üyelik oluştur") {
                register()
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.green)
            .cornerRadius(10)
            
            Spacer()
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Hata"), message: Text(alertMessage), dismissButton: .default(Text("Tamam")))
        }
    }
    
    private func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                let errorMessage = error.localizedDescription
                alertMessage = "Kayıt oluştururken bir hata oluştu: \(errorMessage)"
                showAlert = true
            } else {
                let myUserDictionary: [String: Any] = ["username": self.username, "email": self.email, "useruidfromfirebase": result!.user.uid]
                
                db.collection("Users").addDocument(data: myUserDictionary) { error in
                    if let error = error {
                        let errorMessage = error.localizedDescription
                        alertMessage = "Kayıt oluştururken bir hata oluştu: \(errorMessage)"
                        showAlert = true
                    } else {
                        // Registration successful, navigate to the main screen
                        redirectToMainView(firebaseuid: (result?.user.uid)!)
                    }
                }
            }
        }
    }
}

private func redirectToMainView(firebaseuid: String) {
    let mainView = MainView(firebaseuid: firebaseuid)
    if let window = UIApplication.shared.windows.first {
        window.rootViewController = UIHostingController(rootView: mainView)
        window.makeKeyAndVisible()
    }
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
