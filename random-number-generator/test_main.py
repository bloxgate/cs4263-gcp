import unittest
from collections import Counter
from main import get_random


class MyTestCase(unittest.TestCase):
    def test_random(self):
        for i in range(10):
            numbers = [None] * 1000
            for j in range(1000):
                numbers[j] = int(get_random())
            self.assertTrue(len(set(numbers)) > 750)



if __name__ == '__main__':
    unittest.main()
