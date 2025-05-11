class myClass:
    def __init__(self, name: str) -> None:
        self.name = name

    def print_name(self):
        """
        testMyClass
        freak class dada ya
        """
        return self.name


def main():
    return 10


testMyClass = myClass("freak")
print(testMyClass.print_name())
