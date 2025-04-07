import unittest
import json
from app import app

class TestApp(unittest.TestCase):
    def setUp(self):
        self.app = app.test_client()
        self.app.testing = True

    def test_hello_endpoint(self):
        response = self.app.get('/')
        data = json.loads(response.get_data())
        self.assertEqual(response.status_code, 200)
        self.assertEqual(data['message'], 'Hello, DevOps!')
    
    def test_health_endpoint(self):
        response = self.app.get('/health')
        data = json.loads(response.get_data())
        self.assertEqual(response.status_code, 200)
        self.assertEqual(data['status'], 'healthy')

if __name__ == '__main__':
    unittest.main()