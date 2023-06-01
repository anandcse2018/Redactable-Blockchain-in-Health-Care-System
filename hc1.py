import hashlib
import json
from datetime import datetime

class ChameleonHash:
    def __init__(self):
        self.key = hashlib.sha256().digest()  # Replace with your desired key

    def update(self, data):
        # Update the hash function with the provided data
        self.key = hashlib.sha256(self.key + data).digest()

    def digest(self):
        return self.key.hex()

class PatientRecord:
    def __init__(self, patient_id, timestamp, data, previous_hash, redactable=True):
        self.patient_id = patient_id
        self.timestamp = timestamp
        self.data = data
        self.previous_hash = previous_hash
        self.redactable = redactable
        self.hash = self.generate_hash()

    def generate_hash(self):
        record_contents = {
            "patient_id": self.patient_id,
            "timestamp": self.timestamp.strftime('%Y-%m-%d %H:%M:%S'),
            "data": self.data,
            "previous_hash": self.previous_hash,
        }
        record_contents_encoded = json.dumps(record_contents, sort_keys=True).encode('utf-8')
        if self.redactable:
            hash_func = ChameleonHash()
            hash_func.update(record_contents_encoded)
            return hash_func.digest()
        else:
            return hashlib.sha256(record_contents_encoded).hexdigest()

    def redact(self, key):
        if self.redactable:
            hash_func = ChameleonHash()
            hash_func.update(key)
            self.data = hash_func.digest()

    def is_redactable(self):
        return self.redactable

    def is_redacted(self):
        return self.data is None

class HealthcareBlockchain:
    def __init__(self):
        self.records = [PatientRecord("Genesis Block", datetime.now(), "Genesis Block", None, redactable=False)]

    def add_record(self, patient_id, data, redactable=True):
        previous_hash = self.records[-1].hash
        record = PatientRecord(patient_id, datetime.now(), data, previous_hash, redactable)
        self.records.append(record)

    def get_record(self, index):
        return self.records[index]

    def redact_record(self, index, key):
        record = self.records[index]
        if record.is_redactable() and not record.is_redacted():
            record.redact(key)
            # rehash all subsequent records
            for i in range(index+1, len(self.records)):
                previous_hash = self.records[i-1].hash
                record = PatientRecord(self.records[i].patient_id, datetime.now(), self.records[i].data, previous_hash, self.records[i].redactable)
                self.records[i].hash = record.generate_hash()

    def get_all_records(self):
        return self.records

if __name__ == "__main__":
    # create a new blockchain
    blockchain = HealthcareBlockchain()

    # add some patient records
    blockchain.add_record("patient1", "Patient 1 data")
    blockchain.add_record("patient2", "Patient 2 data", redactable=True)
    blockchain.add_record("patient3", "Patient 3 data", redactable=True)
    blockchain.add_record("patient4", "Patient 4 data")

    # get all records
    all_records = blockchain.get_all_records()
    for record in all_records:
        print(f"Record {all_records.index(record)}: Patient ID - {record.patient_id}, Timestamp - {record.timestamp}, Data - {record.data}, Hash - {record.hash}")
    print("\n");
    
    # redact a record
    index_to_redact = 2
    key = b"secret_key"
    blockchain.redact_record(index_to_redact, key)
   
    # get all records again
    all_records = blockchain.get_all_records()
    for record in all_records:
        print(f"Record {all_records.index(record)}: Patient ID - {record.patient_id}, Timestamp - {record.timestamp}, Data - {record.data}, Hash - {record.hash}")
