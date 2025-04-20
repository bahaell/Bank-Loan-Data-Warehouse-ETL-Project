import pandas as pd
from pymongo import MongoClient

# Connexion à MongoDB
# Remplacez l'URI si vous utilisez un serveur distant ou MongoDB Atlas
client = MongoClient('mongodb://localhost:27017/')

# Sélectionner la base de données et la collection
db = client['BankLoanDB']
collection = db['LoanSource']

# Charger le fichier CSV
csv_file = 'dim_loan.csv'  # Ajustez le chemin selon votre fichier
df = pd.read_csv(csv_file)

# Convertir le DataFrame en une liste de dictionnaires
records = df.to_dict('records')

# Insérer les documents dans la collection
if records:
    collection.insert_many(records)
    print(f"{len(records)} documents insérés dans la collection LoanSource.")
else:
    print("Aucune donnée à insérer.")

# Fermer la connexion
client.close()