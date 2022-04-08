//
//  ViewController.swift
//  ProjetoAPI
//
//  Created by user213614 on 4/7/22.
//

import UIKit

class ViewController: UIViewController {

    var indexPessoas: Int = -1
    @IBOutlet weak var imagemOulet: UIImageView!
    
    var pessoaId: Pessoas?
    let pessoas = Pessoas()
    
    @IBOutlet weak var botaoOutlet: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var segundoNomeTextField: UITextField!
    @IBOutlet weak var primeiroNomeTextField: UITextField!
    
    
    @IBAction func botaoAction(_ sender: Any) {
        if let p = pessoaId{
            edit()
        } else {
        save()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let p = pessoaId{
            primeiroNomeTextField.text = pessoaId?.first_name
            segundoNomeTextField.text = pessoaId?.last_name
            emailTextField.text = pessoaId?.email
            setImage()
//
//            imagemOulet.image = imagem
        }
        
    }
    func setImage(){
            let url = URL (string: pessoaId!.avatar!)
            
            do{
                let data = try Data(contentsOf: url!)
                
                imagemOulet.image = UIImage(data: data)
            }
            catch {
                print("Erro ao baixar a imagem")
            }
            
        }
    
    func save(){
        let url = URL(string: "https://reqres.in/api/users")!
        
        var requisicao = URLRequest(url: url)
        requisicao.httpMethod = "POST"
        
        let user = URLSession.shared.dataTask(with: requisicao, completionHandler: {
            (dados, resposta, erro) in
            if (erro == nil){
                print("Pessoa criada")
            } else {
                print("Erro ao criar pessoa")
            }
        })
        
        requisicao.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
       
        
        pessoas.first_name = primeiroNomeTextField.text
        pessoas.last_name = segundoNomeTextField.text
        pessoas.email = emailTextField.text
        
        
        let encoder = JSONEncoder()
        do{
            requisicao.httpBody = try encoder.encode(pessoas)
            print("Adicionado com sucesso")
            
        }
        catch {
            print("Erro ao converter")
        }
        
        
        user.resume()
    }
    
    func edit(){
        let url = URL(string: "https://reqres.in/api/users/\(pessoaId!.id!)")!
        
        var requisicao = URLRequest(url: url)
        requisicao.httpMethod = "PATCH"
        
        let user = URLSession.shared.dataTask(with: requisicao, completionHandler: {
            (dados, resposta, erro) in
            if (erro == nil){
                print("Pessoa criada")
            } else {
                print("Erro ao editar pessoa")
            }
        })
        
        requisicao.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let pessoas = Pessoas()
        
        pessoas.first_name = primeiroNomeTextField.text
        pessoas.last_name = segundoNomeTextField.text
        pessoas.email = emailTextField.text
        
        
        let encoder = JSONEncoder()
        do{
            requisicao.httpBody = try encoder.encode(pessoas)
            print("Editado com sucesso")
            
        }
        catch {
            print("Erro ao converter")
        }
        
        
        user.resume()
    }

}

