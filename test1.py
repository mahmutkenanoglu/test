def add(a, b):
    return a + b

def multiply(a, b):
    return a * b

def test_add():
    assert add(2, 3) == 5
    assert add(0, 0) == 0
    assert add(-1, 1) == 0

def test_multiply():
    assert multiply(2, 3) == 6
    assert multiply(0, 5) == 0
    assert multiply(-2, 4) == -8

def run_tests():
    test_add()
    test_multiply()
    print("All tests passed!")
    print('Congrats')

if __name__ == "__main__":
    run_tests()
