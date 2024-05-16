import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
TMP_PATH = 'UNIV_LIST/JBNU/'

class Firestore:
    def __init__(self):
        # Use the application default credentials
        cred = credentials.ApplicationDefault()
        firebase_admin.initialize_app(cred, {
          'projectId': 'capstonejbnuteam8',
        })
        self.db = firestore.client()

    def add_data(self, collection, data):
        doc_ref = self.db.collection(collection).add(data)
        return doc_ref
    
    def get_data(self, collection, doc):
        doc_ref = self.db.collection(collection).document(doc)
        doc = doc_ref.get()
        return doc.to_dict()
    
    def update_data(self, collection, doc, data):
        doc_ref = self.db.collection(collection).document(doc)
        doc_ref.update(data)

    def search_data(self, collection, field, op, value):
        docs = self.db.collection(collection).where(field, op, value).stream()
        return docs
    
    def search_value_in_all_fields(self, collection, value):
        docs = self.db.collection(collection).stream()
        matching_docs = []

        for doc in docs:
            doc_dict = doc.to_dict()
            if value in doc_dict.values():
                matching_docs.append(doc)

        return matching_docs