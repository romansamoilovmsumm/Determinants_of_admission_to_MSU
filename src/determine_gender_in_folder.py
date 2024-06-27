import os
import pandas as pd
import easygui

def determine_gender(full_name):
    male_keywords = ['ивич', 'ович', 'ич', 'ё', 'онов', 'ов', 'ий', 'ун', 'кан', 'ан']
    female_keywords = ['овна', 'евна', 'ична', 'на', 'ая', 'ина', 'ызар', 'ызара', 'уза', 'укра']
    
    if isinstance(full_name, str):  # Проверяем, что значение является строкой
        name_parts = full_name.lower().split()
        first_name = name_parts[-1]  # Получаем только имя из ФИО
        for keyword in male_keywords:
            if first_name.endswith(keyword):
                return 1
        for keyword in female_keywords:
            if first_name.endswith(keyword):
                return 0
    return None

def process_excel_file(file_path):
    try:
        xls = pd.ExcelFile(file_path)
        sheet_names = xls.sheet_names
        for sheet_name in sheet_names:
            df = pd.read_excel(xls, sheet_name=sheet_name)
            fio_column = None
            for column in df.columns:
                if 'Фамилия, имя, отчество' in column:
                    fio_column = column
                    break
            if fio_column is None:
                print(f"В листе '{sheet_name}' файла {file_path} не найден столбец 'Фамилия, имя, отчество' или его альтернатива.")
                continue
            genders = []
            for idx, row in df.iterrows():
                fio_value = row[fio_column]
                if pd.isnull(fio_value) or fio_value == 'Фамилия, имя, отчество':
                    genders.append(None)
                    continue
                gender = determine_gender(fio_value)
                if gender is None:
                    msg = f"Не удалось определить пол для записи:\n{fio_value}\nПожалуйста, укажите пол для этой записи:"
                    title = "Укажите пол"
                    choices = ["Мужской", "Женский", "Пустая ячейка"]
                    choice = easygui.buttonbox(msg, title, choices)
                    if choice == "Мужской":
                        gender = 1
                    elif choice == "Женский":
                        gender = 0
                    elif choice == "Пустая ячейка":
                        gender = None
                genders.append(gender)
            df['Пол'] = genders
            new_file_path = os.path.splitext(file_path)[0] + f"_{sheet_name}_with_gender.xlsx"
            df.to_excel(new_file_path, index=False)
    except Exception as e:
        print(f"Произошла ошибка при обработке файла: {file_path}")
        print(e)

def process_folder(folder_path):
    for root, dirs, files in os.walk(folder_path):
        for file in files:
            if file.endswith('.xlsx'):
                file_path = os.path.join(root, file)
                process_excel_file(file_path)

# Укажите путь к вашей папке с файлами
folder_path = '.'
process_folder(folder_path)

