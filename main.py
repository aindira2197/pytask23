class Observer:
    def update(self, message):
        pass

class User(Observer):
    def __init__(self, name):
        self.name = name

    def update(self, message):
        print(self.name + " received message: " + message)

class Subject:
    def __init__(self):
        self.observers = []

    def attach(self, observer):
        self.observers.append(observer)

    def detach(self, observer):
        self.observers.remove(observer)

    def notify(self, message):
        for observer in self.observers:
            observer.update(message)

class Chat(Subject):
    def __init__(self):
        super().__init__()

    def send_message(self, user, message):
        print(user.name + " sent message: " + message)
        self.notify(message)

user1 = User("John")
user2 = User("Alice")
user3 = User("Bob")

chat = Chat()
chat.attach(user1)
chat.attach(user2)
chat.attach(user3)

chat.send_message(user1, "Hello, everyone!")
chat.send_message(user2, "Hi, John!")
chat.send_message(user3, "Hey, guys!")

chat.detach(user2)
chat.send_message(user1, "Private message to Alice and Bob")