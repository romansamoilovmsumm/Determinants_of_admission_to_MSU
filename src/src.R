# Загрузка необходимых библиотек
library(openxlsx)
library(plm)
library(clubSandwich)

# Загрузка данных
data <- read.csv("общая_таблица.csv")
data_w <- read.csv("общая_таблица_w.csv")
data_m <- read.csv("общая_таблица_m.csv")
data_n <- read.csv("общая_таблица_n.csv")
data_y <- read.csv("общая_таблица_y.csv")

# Создание панели данных
panel_data <- pdata.frame(data, index = c("faculty_specialty", "year"))
panel_data_w <- pdata.frame(data_w, index = c("faculty_specialty", "year"))
panel_data_m <- pdata.frame(data_m, index = c("faculty_specialty", "year"))
panel_data_n <- pdata.frame(data_n, index = c("faculty_specialty", "year"))
panel_data_y <- pdata.frame(data_y, index = c("faculty_specialty", "year"))


# Первая модель: фиксированные эффекты по индивидуумам
model_FE <- plm(
  passing_score ~ num_bvi + num_target_students + num_quota_students + num_student + I(num_student^2)+ average_score + faculty_humanities + abbreviation_length + num_budget_places + specialist_or_bachelor + avg_additional_points,
  data = panel_data,
  effect = "individual",
  model = "within"
)

# Вторая модель: случайные эффекты по индивидуумам
model_RE <- plm(
  passing_score ~ num_bvi + num_target_students + num_quota_students + num_student + I(num_student^2)+ average_score + faculty_humanities + abbreviation_length + num_budget_places + specialist_or_bachelor + avg_additional_points,
  data = panel_data,
  effect = "individual",
  model = "random"
)

# Третья модель: pooled

model_Pooled <- plm(
  passing_score ~ num_bvi + num_target_students + num_quota_students + num_student + I(num_student^2)+ average_score + faculty_humanities + abbreviation_length + num_budget_places + specialist_or_bachelor + avg_additional_points,
  data = panel_data,
  effect = "individual",
  model = "pooling"
)

# Сводка по моделям
summary(model_FE, vcov = vcovHC(model_FE))  # Используем HC SE для устойчивости к гетероскедастичности
summary(model_RE, vcov = vcovHC(model_RE))
summary(model_Pooled, vcov = vcovHC(model_Pooled))

# Тест Хаусмана для определения типа модели
hausman_test <- phtest(model_RE, model_FE)
print(hausman_test)

# Проведение теста Бройша-Пагана для сравнения "пул" с RE
bp_test <- plmtest(model_RE, type = "bp", effect = "individual")
print(bp_test)

f_test <- pFtest(model_FE, model_Pooled)
print(f_test)

# Лучше RE
# Первая модель: фиксированные эффекты по индивидуумам
model_RE_w <- plm(
  passing_score ~ num_bvi + num_target_students + num_quota_students + num_student + I(num_student^2)+ average_score + faculty_humanities + abbreviation_length + num_budget_places + specialist_or_bachelor + avg_additional_points,
  data = panel_data_w,
  effect = "individual",
  model = "random"
)
model_RE_m <- plm(
  passing_score ~ num_bvi + num_target_students + num_quota_students + num_student + I(num_student^2)+ average_score + faculty_humanities + abbreviation_length + num_budget_places + specialist_or_bachelor + avg_additional_points,
  data = panel_data_m,
  effect = "individual",
  model = "random"
)
model_RE_n <- plm(
  passing_score ~ num_bvi + num_target_students + num_quota_students + num_student + I(num_student^2)+ average_score + faculty_humanities + abbreviation_length + num_budget_places + specialist_or_bachelor + avg_additional_points,
  data = panel_data_n,
  effect = "individual",
  model = "random"
)
model_RE_y <- plm(
  passing_score ~ num_bvi + num_target_students + num_quota_students + num_student + I(num_student^2)+ average_score + faculty_humanities + abbreviation_length + num_budget_places + specialist_or_bachelor + avg_additional_points,
  data = panel_data_y,
  effect = "individual",
  model = "random"
)

summary(model_RE_w, vcov = vcovHC(model_RE_w))
summary(model_RE_m, vcov = vcovHC(model_RE_m))
summary(model_RE_n, vcov = vcovHC(model_RE_n))
summary(model_RE_y, vcov = vcovHC(model_RE_y))
summary(model_RE, vcov = vcovHC(model_RE))


##################################################

# Загрузка пакета
library(stargazer)

stargazer(
  model_RE,
  type = "latex",
  title = "Модель со случайными эффектами",
  style = "default",
  summary = TRUE,
  se = list(sqrt(diag(vcovHC(model_RE)))),
  out = "model_RE_table_3.tex"
)

stargazer(
  model_RE, model_FE, model_Pooled,
  type = "latex",
  title = "Сравнение моделей",
  style = "default",
  summary = TRUE,  # Включение сводных статистик
  se =  list(sqrt(diag(vcovHC(model_RE))), sqrt(diag(vcovHC(model_FE))), sqrt(diag(vcovHC(model_Pooled)))),  # Стандартные ошибки
  out = "combined_model_table_1.tex"  # Опционально: вывод в файл LaTex
)

# Создание одной таблицы для нескольких моделей
stargazer(
  model_RE, model_RE_w, model_RE_m, model_RE_n, model_RE_y, 
  type = "latex",
  title = "Сравнение подвыборок (женщины, мужчины, москвичи, не москвичи)",
  style = "default",
  summary = FALSE,  # Включение сводных статистик
  se = list(sqrt(diag(vcovHC(model_RE))), sqrt(diag(vcovHC(model_RE_w))), sqrt(diag(vcovHC(model_RE_m))), sqrt(diag(vcovHC(model_RE_n))), sqrt(diag(vcovHC(model_RE_y))) ),  # Стандартные ошибки
  out = "combined_model_table_2.tex"  # Опционально: вывод в файл LaTex
)

