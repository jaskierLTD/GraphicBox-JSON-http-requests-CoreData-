import Foundation
import Alamofire
import SwiftyJSON

struct Item : Decodable {
    let noteId:Int
    let title:String
    let content:String
    let version: Int
    let created: Int32
    let modified: Int32
    
    private enum CodingKeys : String, CodingKey {
        case title,content,version,created,modified,noteId = "note_id"
    }
}

class APIManager
{
    var idArray = [Int]()
    var titleArray = [String]()
    var contentArray = [String]()
    var defaults = UserDefaults.standard
    
    // MARK: - POST request -
    func POST(_ sender: Any)
    {
        let headers = [
            "content-type": "application/json",
            "x-auth-header": "fb2f56fde81f21926fc0b5b74702f71da9f152efa7b5587a308984b71c9acac7fd44da05583ab06d57d29794f59fc475d9f2d132cbc6e29c421f11330a30a613"
        ]
        let parameters = [
            "title": "title666",
            "content": "content666"
            ] as [String : Any]
        do{
        let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])

        let request = NSMutableURLRequest(url: NSURL(string: "http://rekrutacja.backendzs.pl/note/")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse as Any)
            }
        })
        dataTask.resume()
        } catch {
            print("json error: \(error.localizedDescription)")
        }
    }

    // MARK: - GET request -
    func GET(_ sender: Any)
    {
        let headers = [
            "x-auth-header": "fb2f56fde81f21926fc0b5b74702f71da9f152efa7b5587a308984b71c9acac7fd44da05583ab06d57d29794f59fc475d9f2d132cbc6e29c421f11330a30a613",
            "content-type": "application/x-www-form-urlencoded"
        ]
        
        //let postData = NSData(data: "".data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://rekrutacja.backendzs.pl/note/")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        //request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                //response check for errors (200 is ok)
                //let httpResponse = response as? HTTPURLResponse
                //print(httpResponse as Any)
                do
                {
                    let items = try JSONDecoder().decode([Item].self, from: data!)
                    
                    for i in 0...items.count-1{
                        self.idArray.append(items[i].noteId)
                        self.defaults.set(self.idArray, forKey: "idArray2")
                        self.titleArray.append(items[i].title)
                        self.defaults.set(self.titleArray, forKey: "titleArray2")
                        self.contentArray.append(items[i].content)
                        self.defaults.set(self.contentArray, forKey: "contentArray2")
                        //print(items[i].title)
                        //print(items[i].content)
                        //print(items[i].noteId)
                    }
                }
                catch {
                    print(error)
                }
            }
        })
        
        dataTask.resume()
        // MARK: - Objective-C method (DATA IS NOT BEING PARSED)
        /*let instanceOfCustomObject: getObjective = getObjective()
         instanceOfCustomObject.someProperty = "Hello World"
         print(instanceOfCustomObject.someProperty)
         instanceOfCustomObject.getMethod()*/
    }
    
    // MARK: - DELETE request -
    func DELETE(_ sender: Any) {
        let headers = ["x-auth-header": "fb2f56fde81f21926fc0b5b74702f71da9f152efa7b5587a308984b71c9acac7fd44da05583ab06d57d29794f59fc475d9f2d132cbc6e29c421f11330a30a613"]
        
        let postData = NSData(data: "".data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://rekrutacja.backendzs.pl/note/4")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "DELETE"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse as Any)
            }
        })
        dataTask.resume()
    }
    
    // MARK: - PUT request -
    func PUT(_ sender: Any)
    {
        let headers = [
            "content-type": "application/json",
            "x-auth-header": "fb2f56fde81f21926fc0b5b74702f71da9f152efa7b5587a308984b71c9acac7fd44da05583ab06d57d29794f59fc475d9f2d132cbc6e29c421f11330a30a613"
        ]
        let parameters = [
            "title": "Nowy tytuł",
            "content": "Nowa treść"
            ] as [String : Any]
        do{
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            let request = NSMutableURLRequest(url: NSURL(string: "http://rekrutacja.backendzs.pl/note/4")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "PUT"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error as Any)
                } else {
                    let httpResponse = response as? HTTPURLResponse
                    print(httpResponse as Any)
                }
            })
            
            dataTask.resume()
        } catch {
            print("json error: \(error.localizedDescription)")
        }
    }
}
