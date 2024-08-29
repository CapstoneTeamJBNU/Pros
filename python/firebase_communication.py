import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
CRED_PATH = './Firebase/Keys/capstonejbnuteam8-firebase-adminsdk-oyel5-55cda941a1.json'

# Initialize Firebase Admin SDK
cred = credentials.Certificate(CRED_PATH)
firebase_admin.initialize_app(cred)

# Get a Firestore client
db = firestore.client()

def set_data(path, dict):
    '''
    Path can be an empty document. ( if / finished with odd )
    else / finished with even -> document id will set manually
    '''
    goto_ref(path).set(dict)

def update_data(path, dict):
    goto_ref(path).update(dict)

def delete_data(path):
    goto_ref(path).delete()

def goto_ref(path):
    path_str = path.split('/')
    reference = db
    for idx,content in enumerate(path_str):
        if idx % 2 != 0:
            reference = reference.document(content)
        else:
            reference = reference.collection(content)
        if idx == len(path_str) - 1:
            if idx % 2 == 0:
                reference = reference.document()
    return reference

set_data('UNIV_LIST/JBNU',{'something':''})
set_data('UNIV_LIST',{'temp':''})