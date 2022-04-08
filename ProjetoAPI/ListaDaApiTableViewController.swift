//
//  ListaDaApiTableViewController.swift
//  ProjetoAPI
//
//  Created by user213614 on 4/7/22.
//

import UIKit

class ListaDaApiTableViewController: UITableViewController {

    var listaDePessoas: [Pessoas] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: "https://reqres.in/api/users"){
            let lista = URLSession.shared.dataTask(with: url, completionHandler: {
                (dados, requisicao, erro) in
                
                if erro == nil{
                    print("Dados capturados da API com sucesso")
                    
                    let jDecoder = JSONDecoder()
                    
                    if let dadosRetornados = dados{
                        do{
                            let pessoas = try jDecoder.decode(InitApi.self, from: dadosRetornados)
                            
                            for i in pessoas.data {
                                self.listaDePessoas.append(i)
                            }
                            self.tableView.reloadData()
                        }
                        catch{
                            print("Erro ao converter Pessoas")
                        }
                        
                    } else {
                        print("Erro ao consultar API")
                    }
                }
            })
                lista.resume()
            }
        }
        
    
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listaDePessoas.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        cell.textLabel?.text = self.listaDePessoas[indexPath.row].first_name

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let id = listaDePessoas[indexPath.row].id!
            
            let urlD = "https://reqres.in/api/users/\(id)"
            let url = URL(string: urlD)!
            
            var requisicao = URLRequest(url: url)
            requisicao.httpMethod = "DELETE"
            
            requisicao.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let pessoas = URLSession.shared.dataTask(with: requisicao){
                (dados, resposta, erro) in
                if (erro == nil){
                    
                    self.listaDePessoas.remove(at: indexPath.row)
                    print("Pessoa deletar")
                    tableView.deleteRows(at: [indexPath], with: .fade)
                } else {
                    print("Erro ao criar pessoa")
                }
            }
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
                //pegando o professor que gostariamos de alterar
        let pessoaUtil = listaDePessoas[indexPath.row]
        performSegue(withIdentifier: "segueViewController", sender: pessoaUtil)

        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueViewController"{
            
            let destinoControlador = segue.destination as! ViewController
            
            guard let i = sender as? Pessoas else{ return }
            
            destinoControlador.pessoaId = i
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
