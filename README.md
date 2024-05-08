# Determinants_of_admission_to_MSU
The repository is dedicated to the econometric project, which examines the relationship between indicators from applicant lists and passing scores.

Данные были собраны при помощи Wayback Machine https://cpk.msu.ru/rating. Для разделения данных по годам использовалась утилита wayback-machine-downloader https://github.com/hartator/wayback-machine-downloader, которая позволяет скачивать данные из снапшотов только за определённый год (или промежуток времени). Данные за проходной балл взяты с официального сайта МГУ (https://msu.ru/entrance/pr-b-2019.php, https://msu.ru/entrance/pr-b-2018.php, https://msu.ru/entrance/pr-b-2017.php, https://msu.ru/entrance/pr-b.html).

Для конвертации из html файлов в таблицу использовался файл ..., он преобразовывает файл и сохраняет информацию о факультете, направлении и положении студента (общий конкурс, квотник, целевик, бвишник).

Затем файлы переименовываются в формат ... (файл ... формируется вручную скачиванием названий факультета из index.html по соответсвующему году).

Для преобразования итоговых таблиц в общую таблицу использовался файл ...
