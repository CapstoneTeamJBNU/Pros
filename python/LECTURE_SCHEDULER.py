import numpy as np
import pandas as pd

vertical_labels = [f"{i}-{j}" for i in range(14) for j in ["A", "B"]]
horizontal_labels = ["월", "화", "수", "목", "금", "토", "일"]

matrix = np.empty((len(vertical_labels), len(horizontal_labels)), dtype=object)

for i in range(len(vertical_labels)):
    for j in range(len(horizontal_labels)):
        matrix[i][j] = f"{vertical_labels[i]}-{horizontal_labels[j]}"

print(matrix)
# Read the Excel file
df = pd.read_excel('your_file.xlsx')

# Add the lecture data to the matrix
for i in range(len(vertical_labels)):
    for j in range(len(horizontal_labels)):
        matrix[i][j] = f"{vertical_labels[i]}-{horizontal_labels[j]}: {df.iloc[i, j]}"

# Write the updated matrix to a new Excel file
df_updated = pd.DataFrame(matrix, columns=horizontal_labels, index=vertical_labels)
df_updated.to_excel('updated_file.xlsx', index=False)