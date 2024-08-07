# Determinants_of_admission_to_MSU
Репозиторий посвящен эконометрическому проекту, который исследует взаимосвязь показателей из списков абитуриентов и проходных баллов.

Данные были собраны при помощи Wayback Machine https://cpk.msu.ru/rating. Для разделения данных по годам использовалась утилита wayback-machine-downloader https://github.com/hartator/wayback-machine-downloader, которая позволяет скачивать данные из снапшотов только за определённый год (или промежуток времени). Данные за проходной балл взяты с официального сайта МГУ (https://msu.ru/entrance/pr-b-2019.php, https://msu.ru/entrance/pr-b-2018.php, https://msu.ru/entrance/pr-b-2017.php, https://msu.ru/entrance/pr-b.html).

Данные собираюся в общую таблицу (src/Full_table.zip), которая с помощью src/clear_data.ipynb разбивается на отдельные таблицы по годам, факультетам и специальностям. Каждая таблица обрабатывается отдельно и результат обработки записывается в новую общую таблицу. Также в файле src/clear_data.ipynb реализовано разбиение на подвыборки и визуализация качества данных.

В файле src/src.R построены все необходимые регрессии.

Графа гендер генерировалась основываясь на ФИО абитуриента, с помощью программы src/determine_gender_in_folder.py  по отчеству определяется пол, если у неё это не получалось, то появляется окно, в котором показывается ФИО и предлагается самостоятельно выбрать пол или оставить ячейку пола пустой (особенно актуально для китайских студентов)

Результаты работы записаны в файле src/Самойлов_Аксарина_Дугин.pdf.

Из основных можно заметить:

1. Устойчиво и значимо на проходной влияет только средний балл по ЕГЭ. То есть проходной первой волны не только зависит от уверенности в себе абитуриентов с граничным результатом, но и отражает общий спрос на факультет в этом году.

2. Специалитет влияет положительно для иногородних.

3. Если больше 1100 человек в конкурсе, то количества человек начинает влиять отрицательно на проходной балл.

4. Для женщин число букв в названии факультета влияет отрицательно.
