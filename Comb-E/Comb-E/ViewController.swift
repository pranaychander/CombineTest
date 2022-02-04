//
//  ViewController.swift
//  Comb-E
//
//  Created by pranay chander on 19/06/21.
//

///Important Points:
/// 1. Always Store AnyCancellable returned while using sink either in DisposeBag or a Variable.

import UIKit
import Combine

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let center = NotificationCenter.default
    var disposeBag = Set<AnyCancellable>()

    var posts: [Post] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()



        ///SAMPLE CODE METHODS
//        self.noticationMethod()
//        self.stringSubscriberSampleMethod()
//        self.subjects()
//        self.collect()
//        self.map()
//        self.mapKeyPath()
//        self.flatMap()
//        self.replaceNil()
//        self.replaceEmpty()
//        self.scan()
//        self.filter()
//        self.removeDuplicates()
//        self.compactMap()
//        self.ignoreOutput()
//        self.firstLast()
//        self.drop()
//        self.dropUntil()
//        self.prefix()
//        self.prepend()
//        self.append()
//        self.switchToLatest()
//        self.switchToLatest2()
//        self.merge()
//        self.combineLatest()
//        self.zip()
//        self.minMax()
//        self.output()
//        self.count()
//        self.contains()
//        self.allSatisfy()
//        self.reduce()
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
//        self.urlRequest()


        //DEBUG Combine
//        self.debug1()
//        self.debug2()
//        self.debug3()
//        self.runloop()
//        self.timer()
//        self.timerByDPQ()
//        self.share()
//        self.multicast()

    }
}

extension ViewController {
    func noticationMethod() {
        //Imperative Notification
        let observer = center.addObserver(forName: .sampleNotif, object: nil, queue: nil) { notification in
            print("Notification Recieved")
        }
        center.post(name: .sampleNotif, object: nil)
        center.removeObserver(observer)

        //Reactive Notification
        let publisher = center.publisher(for: .sampleNotif, object: nil)

        let subscriber = publisher.sink { _  in
            print("Notification Recieved")
        }

        center.post(name: .sampleNotif, object: nil)

        subscriber.cancel() //Cancel Subscription if not needed, Gets automatically cancelled outside the scope in which it is declared, Here i.e ViewDidLoad.
    }
}

extension Notification.Name {
    static let sampleNotif = Notification.Name(rawValue: "sampleNotification")
}

extension ViewController {
    func stringSubscriberSampleMethod() {
        let publisher = ["A","B","C","D","E","F","G","H","I","J","K"].publisher

        let subscriber = StringSubscriber()

        publisher.subscribe(subscriber)
    }
}

class StringSubscriber: Subscriber {
    typealias Input = String
    typealias Failure = Never

    func receive(subscription: Subscription) {
        print("Recieved Subscription")
        subscription.request(.max(3)) //Back Pressure.Limit Items recieved.
    }

    func receive(_ input: String) -> Subscribers.Demand {
        print("Recieved Value =\(input)")
        return .max(1) //Change Demand here. Increace Demand by 1 each time.
    }

    func receive(completion: Subscribers.Completion<Never>) {
        print("Completed")
    }
}

extension ViewController {
    func subjects() {
        //Subjects -
            // - Publisher
            // - Subscribers

        let subscriber = StringSubscriber1()

        let subject = PassthroughSubject<String, MyError>()

        let sub = PassthroughSubject<String, MyError>().eraseToAnyPublisher() //Hides subjet Type. Similiar to TypeAliasing, Cant use send() method, Can only use SINK


        subject.subscribe(subscriber)

        let subscription = subject.sink {  compleetion in
            print("Recieved Completion from Sink")
        } receiveValue: { value in
            print("Recieved value from Sink")
        }


        subject.send("A")
        subject.send("B")

        subscription.cancel()

        subject.send("C")


    }
}

enum MyError: Error {
    case subscriberError
}

class StringSubscriber1: Subscriber {
    typealias Input = String
    typealias Failure = MyError

    func receive(subscription: Subscription) {
        subscription.request(.max(2))
    }

    func receive(_ input: String) -> Subscribers.Demand {
        print(input)
        return .none
    }

    func receive(completion: Subscribers.Completion<MyError>) {
        print("Completed")
    }
}

extension ViewController {
    func collect() {
        ["A","B","C","D","E"].publisher
            .collect(2) ///Gives an Array of Strings
            .sink {
                print($0)
            }
    }
}

extension ViewController {
    func map() {
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        [123,787,77,899].publisher.map {
            formatter.string(from: NSNumber(integerLiteral: $0))
        }
        .sink {
            print($0)
        }
    }
}

extension ViewController {
    func mapKeyPath() {
        let publisher = PassthroughSubject<Point, Never>()

        publisher.map(\.x, \.y)
            .sink { x, y in
                print(x, y)
            }
            .store(in: &disposeBag)

        publisher.send(Point(x: 332, y: 909))

    }
}

struct Point {
    let x: Int
    let y: Int
}

extension ViewController {
    func flatMap() {

        let citySchool = School(name: "ASK", noOfStudents: 67)

        let school = CurrentValueSubject<School, Never>(citySchool)

        school
            .flatMap {
                $0.noOfStudents
            }
            .sink {
                print($0)
            }
            .store(in: &disposeBag)

        let townSchool = School(name: "Primus", noOfStudents: 167)
        school.value = townSchool

        citySchool.noOfStudents.value += 11
        townSchool.noOfStudents.value += 90

    }
}

struct School {
    let name: String
    let noOfStudents: CurrentValueSubject<Int, Never>

    init(name: String, noOfStudents: Int) {
        self.name = name
        self.noOfStudents = CurrentValueSubject(noOfStudents)
    }
}

extension ViewController {
    func replaceNil() {
        ["A", "B", "C", nil, "E"].publisher
            .replaceNil(with: "*")
            .map{
                $0!
            }
            .sink {
                print($0) ///Prints All Optionals
            }
    }
}

extension ViewController {
    func replaceEmpty() {
        let empty = Empty<Int, Never>()

        empty
            .replaceEmpty(with: 1111)
            .sink {
                print($0)
            } receiveValue: {
                print($0)
            }


    }
}

extension ViewController {
    func scan() {
        let pubL = (1...10).publisher

        pubL.scan([]) { numbers, value -> [Int] in
            numbers + [value]
        }
        .sink {
            print($0)
        }

    }
}

extension ViewController {
    func filter() {
        let numbs = (1...20).publisher

        numbs.filter {
            $0 % 2 == 0
        }
        .sink {
            print($0)
        }

    }
}

extension ViewController {
    func removeDuplicates() {
        let fruits = "apple apple mango grape apple apple".components(separatedBy: " ").publisher

        fruits
            .removeDuplicates()
            .sink {
            print($0)
        }
    }
}

extension ViewController {
    func compactMap() {
        let str = ["a", "1.24", "78", "busy", "nate"].publisher
            .compactMap { Float($0) }
            .sink { print($0) }
    }
}

extension ViewController {
    func ignoreOutput() {
        let numbers = (1...5000).publisher
        numbers
            .ignoreOutput()
            .sink {
                print($0)
            } receiveValue: {
                print($0)
            }
    }
}

extension ViewController {
    func firstLast() {
        let numbers = (1...9).publisher
        numbers
            .first(where: {
                $0 % 2 == 0
            })
            .sink {
                print($0)
            }

        numbers
            .last(where: {
                $0 % 2 == 0
            })
            .sink {
                print($0)
            }
    }
}

extension ViewController {
    func drop() {

        //DropFirst
        let numbers = (1...10).publisher
//        numbers
//            .dropFirst(5)
//            .sink {
//                print($0)
//            }

        //Drop while only drops until first condition turns false.
        numbers
            .drop { $0 % 3 != 0 }
            .sink { print($0) }
    }
}

extension ViewController {
    func dropUntil() {
        let isReady = PassthroughSubject<Void, Never>()
        let taps = PassthroughSubject<Int, Never>()

        taps
            .drop(untilOutputFrom: isReady)
            .sink { print($0 )}
            .store(in: &disposeBag)

        taps.send(2) // Doesn't work as it is dropped
        taps.send(34) // Doesn't work as it is dropped

        isReady.send() // Green Flag to proceed with publishing. Depends on another publisher.

        taps.send(8989)

    }
}

extension ViewController {
    func prefix() {
        let nums = (1...100).publisher
        nums
            .prefix(3)
            .sink { print($0) }

        nums
            .prefix { $0 > 3}
            .sink { print($0) }
    }
}

extension ViewController {
    func prepend() {
        let numbers = (1...5).publisher
        let pub2 = (500...510).publisher

        numbers
            .prepend (100, 101)
            .prepend([45, 90])
            .prepend(pub2)
            .sink { print($0) }
    }
}

extension ViewController {
    func append() {
        let numbers = (1...5).publisher
        let pub2 = (500...510).publisher

        numbers
            .append(100, 101)
            .append([45, 90])
            .append(pub2)
            .sink { print($0) }
    }
}

extension ViewController {
    func switchToLatest() {
        let pub1 = PassthroughSubject<String, Never>()
        let pub2 = PassthroughSubject<String, Never>()

        let pubs = PassthroughSubject< PassthroughSubject<String, Never>, Never>()

        pubs
            .switchToLatest()
            .sink { print($0) }
            .store(in: &disposeBag)

        pubs.send(pub1)

        pub1.send("PUB 1 SENT 1")
        pub1.send("PUB 1 SENT 2")

        pubs.send(pub2)
        pub2.send("PUB 2 SENT 1")

        pub1.send("PUB 1 SENT 3") //Not Capture coz of switch to Latest
    }

    func switchToLatest2() {


        let taps = PassthroughSubject<Void, Never>()
        var ind = 0

        taps
            .map { _ in self.getImage(ind: ind) }
            .switchToLatest()
            .sink {print($0)}
            .store(in: &disposeBag)

        taps.send()

        DispatchQueue.main.asyncAfter(deadline: .now() + 6 ) {
            ind += 1
            taps.send()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 6.5 ) {
            ind += 1
            taps.send()
        }

        //order should be house , pencil and trash
        //But Pencil is skipped due to delay and use of switchToLatest

    }

    func getImage(ind: Int) -> AnyPublisher<UIImage?, Never> {
        let images = ["house", "pencil", "trash"]
        return Future<UIImage?, Never> { promise in ///Future returns immeadiately , but body of the future is evaluated after sometime.
            ///Fake Image Download
            DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
                promise(.success(UIImage(systemName: images[ind])))

            }
        }
        .print()
        .map { $0 }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }

}

extension ViewController {
    func merge() { //Combine multiple publishers
        let pub1 = PassthroughSubject<Int, Never>()
        let pub2 = PassthroughSubject<Int, Never>()

        pub1.merge(with: pub2)
            .sink { print($0) }
            .store(in: &disposeBag)

        pub1.send(10)

        pub2.send(100)
    }
}

extension ViewController {
    func combineLatest() { //Latest value from each publisher is combined into a tuple
        let pub1 = PassthroughSubject<Int, Never>()
        let pub2 = PassthroughSubject<String, Never>()

        pub1.combineLatest(pub2)
            .sink { print($0) }
            .store(in: &disposeBag)

        pub1.send(1) //Nothing happens since pub2 doesnt send anything.

        pub2.send("pub 2 - 1")

        pub2.send("pub 2 - 2")

        pub1.send(2)

        pub1.send(3)

        pub2.send("pub 2 - 3")
    }
}

extension ViewController {
    func zip() {

        let pub1 = PassthroughSubject<Int, Never>()
        let pub2 = PassthroughSubject<String, Never>()

        pub1.zip(pub2)
            .sink { print($0) }
            .store(in: &disposeBag)

        pub1.send(1)

        pub2.send("pub 2 - 1")

        pub2.send("pub 2 - 2")

        pub1.send(2)

        pub1.send(3)

        pub2.send("pub 2 - 3")

        pub1.send(4) // Not emitted as no pair available

    }
}

extension ViewController {
    func minMax() {
        let pub = (-1111...10).publisher
        pub.min().sink{ print($0)}
        pub.max().sink{ print($0)}
    }
}

extension ViewController {
    func output() {
        let pub = ["A", "B", "C", "D"].publisher
        pub.output(at: 2).sink { print($0) }

        pub.output(in: 0...2).sink { print($0) }
    }
}

extension ViewController {
    func count() { //Gives number of values emitted and finished completion should be recieved.
        let pub = ["A", "B", "C", "D"].publisher

        let pub2 = PassthroughSubject<Int, Never>()

        pub.count().sink { print($0) }

        pub2.count().sink { print($0) }.store(in: &disposeBag)

        pub2.send(9)
        pub2.send(19)
        pub2.send(29)
        pub2.send(93)
        pub2.send(completion: .finished) // Passthrough Publishers need to get finished Event to display the count.
    }
}

extension ViewController {
    func contains() {
        let pub = ["A", "B", "C", "D"].publisher

        pub.contains("C").sink { print($0) }
        pub.contains("9").sink { print($0) }

    }
}

extension ViewController {
    func allSatisfy() {
        let pub = [2, 70, 190, 6].publisher

        pub.allSatisfy { $0 % 2 == 0}.sink { print($0)}
    }
}

extension ViewController {
    func reduce() {
        let pub = [2, 70, 190, 6].publisher

        pub.reduce(0) { accumulator, value in
            print(accumulator, value)
            return accumulator + value
        }
        .sink { print($0)}
    }
}

extension ViewController {

    func urlRequest() {
        getPosts()
            .catch({ _ in
                Just([Post]())
            })
                    .receive(on: DispatchQueue.main)
                    .assign(to: \.posts, on: self)
                    .store(in: &disposeBag)

//            .sink(receiveCompletion: { _ in }, receiveValue: { print($0) })

    }

    func getPosts() -> AnyPublisher<[Post], Error> {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
        fatalError("Invalid URL")
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Post].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

struct Post: Codable {
    let title: String
    let body: String
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = posts[indexPath.row].title
        cell.detailTextLabel?.text = posts[indexPath.row].body
        return cell
    }
}


extension ViewController {

    func debug1() {
        let pub1 = (1...10).publisher
        pub1
            .print()
            .sink { print($0) }
    }

    func debug2() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
        fatalError("Invalid URL")
        }

        let request = URLSession.shared.dataTaskPublisher(for: url)

        request
            .print()
            .handleEvents(receiveSubscription: { _ in
                print(" Sub Recieved")
            }, receiveOutput: { _ in
                print(" Recieved o/p")
            }, receiveCompletion: { _ in
                print(" Recieved Comple")
            }, receiveCancel: {
                print(" Recieved Cancel")
            }, receiveRequest: { _ in
                print(" Recieved Request")
            })
            .sink {
                print($0)
            } receiveValue: { data, response in
                print(data)
            }
            .store(in: &disposeBag)

    }

    func debug3() {
        //Enable Degubber
        let pub1 = (1...10).publisher
        pub1
            .breakpointOnError()
            .breakpoint(receiveOutput: { value in
                value > 9
            })
            .sink { print($0) }
    }
}

extension ViewController {
    func runloop() {
        let runLoop1 = RunLoop.main

        let sub = runLoop1.schedule(after: runLoop1.now, interval: .seconds(2), tolerance: .milliseconds(100), options: .none) {
            print("Timer fired")
        }


        runLoop1.schedule(after: .init(Date(timeIntervalSinceNow: 3.0))) {
            sub.cancel()
        }
    }

    func timer() {
        let sub = Timer
            .publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .scan(0, { counter, _ in
                counter + 1
            })
            .sink {
                print($0)
            }
            .store(in: &disposeBag)
    }

    func timerByDPQ() {
        let queue = DispatchQueue.main

        let source = PassthroughSubject<Int, Never>()

        var counter = 0

        queue
            .schedule(after: queue.now, interval: .seconds(1.0)) {
                source.send(counter)
                counter += 1
            }
            .store(in: &disposeBag)

        source
            .sink { print($0)}
            .store(in: &disposeBag)
    }
}

extension ViewController {
    func share() {
        /// If multiple subscribers require same data , data / URL fetch doesnt repeat , happens only once
        var subscription3: AnyCancellable? = nil

        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            fatalError("Invalid URL")
        }

        let request = URLSession.shared.dataTaskPublisher(for: url).map(\.data).print().share()

        let subscription1 = request.sink(receiveCompletion: { _ in }, receiveValue: {
            print("Subscription 1")
            print($0)
        }).store(in: &disposeBag)

        let subscription2 = request.sink(receiveCompletion: { _ in }, receiveValue: {
            print("Subscription 2")
            print($0)
        }).store(in: &disposeBag)

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            subscription3 = request.sink(receiveCompletion: { _ in }, receiveValue: {
                print("Subscription 3")
                print($0)
            })
            subscription3?.store(in: &self.disposeBag)
        } ///Doesnt Occur, As Current Subribers only recieve.Issue only if we use Share.
    }

    func multicast() {
        /// If multiple subscribers require same data , data / URL fetch doesnt repeat , happens only once
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            fatalError("Invalid URL")
        }
        let subject = PassthroughSubject<Data, URLError>()
        let request = URLSession.shared.dataTaskPublisher(for: url).map(\.data).print().multicast(subject: subject)

        let subscription1 = request.sink(receiveCompletion: { _ in }, receiveValue: {
            print("Subscription 1")
            print($0)
        }).store(in: &disposeBag)

        let subscription2 = request.sink(receiveCompletion: { _ in }, receiveValue: {
            print("Subscription 2")
            print($0)
        }).store(in: &disposeBag)


           let subscription3 = request.sink(receiveCompletion: { _ in }, receiveValue: {
                print("Subscription 3")
                print($0)
            })
            .store(in: &self.disposeBag)

        request.connect() // Allows connection of all Subscribers
        subject.send(Data())
    }
}
