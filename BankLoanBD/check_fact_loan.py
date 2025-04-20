import csv

csv_file = "staging_fact_loan_clean_fixed.csv"
decimal_columns = ["LoanAmount", "TotalPayment", "Installment", "InterestRate", "DTI", "AnnualIncome"]

try:
    with open(csv_file, "r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        print("[DEBUG] En-têtes:", reader.fieldnames)  # Debug 1
        
        for row_idx, row in enumerate(reader, start=2):
            for col in decimal_columns:
                value = row[col].strip()  # Supprimer les espaces
                if not value:
                    print(f"Ligne {row_idx} - Colonne '{col}': Valeur vide.")
                try:
                    float(value.replace(",", "."))  # Force le remplacement virgule -> point
                except ValueError:
                    print(f"ERREUR Ligne {row_idx} - Colonne '{col}': '{value}'")
except FileNotFoundError:
    print(f"Fichier non trouvé : {csv_file}")
except Exception as e:
    print(f"Erreur inattendue : {e}")