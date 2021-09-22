# Rubik
В данном проекте необходимо написать программу, собирающую Кубик Рубика.

На вход программе подается последовательность поворотов граней, которые запутывают кубик. Программа выдает последовательность поворотов граней, которые приведут к собранному состоянию кубика. 

## Использование
### Консольная версия
Для работы с консольной версией небходимо: 
1. Клонировать ветку main
2. Перейти в папку с исходным кодом
3. Собрать проект (make) 
4. Запустить программу, в качестве параметра передать строку с последовательностью поворотов граней.
---
    

   
        git clone https://github.com/MixFon/Rubik.git
        cd Rubik
        make
        ./rubik_cube "F R U R R U"
        --> F L' L' R2 D U' L' L' U ...


### Графическая версия
Для работы с графической версией необходимо:
1. Клонировать ветку main 
2. Перейти в папку с исходным кодом
3. Открыть файл проекта UIRubik.xcodeproj в XCode
---
        git clone https://github.com/MixFon/Rubik.git
        cd Rubik
        open UIRubik.xcodeproj

## Используемые модели
В проекте для представления кубика были использованы две модели:
1. Массив матриц 3x3
2. Матрица 3x3x3

В массиве матриц в каждой матрице хранится цвет. Данный массив используется для поиска решения.

В трехмерной матрице содержатся номена от 0 до 26. Данная матрица используется для представления кубика в 3D.

Массив матриц 3x3 | Матрица 3x3x3
------------------|--------------
![array matrix](https://github.com/MixFon/Rubik/blob/main/images/0__GKuKu.png) | ![array](https://github.com/MixFon/Rubik/blob/main/images/x7KGxGij.png)

      
## Решение головоломки
### Алгоритм
Для сборки головоломки используется алгоритм "человеческой" сборки, который разделяется на этапов:
1. Правильный крест
2. Углы первого слоя
3. Рёбра среднего слоя
4. Крест последнего слоя
5. Правильный крест в последнем слое
6. Расстановка углов последнего слоя
7. Разворот углов третьего слоя.

Более подробно про данный алгоритм можно ознакомиться [тут](https://speedcubing.com.ua/howto/3x3 "Кубик")

### Автоматическая сборка
После нажатия на кнопку _Solution_ появится последовательность поворотов, которая приведет к решению кубика. Для автоматической сборки кубика нужно зажать кнопку _Q_, для прокрутки назад нужно зажать _W_.
Кнопка _Generate_ генерирует случайную последовательность поворотов.
![Solution](https://github.com/MixFon/Rubik/blob/main/gifs/Solution.gif)

### Самостоятельная сборка
Собирать кубик можно самостоятельно, нажимая соответствующие символы на клавиатуре:
Грань | Символ | Демо
------|----------------------------|----
**F (Front)** | **Z** | ![F](https://github.com/MixFon/Rubik/blob/main/gifs/F.gif)
**F' (Front)**| **X** | ![F'](https://github.com/MixFon/Rubik/blob/main/gifs/F_.gif)
**L (Left)**  | **A** | ![L](https://github.com/MixFon/Rubik/blob/main/gifs/L.gif)
**L' (Left)** | **S** | ![L'](https://github.com/MixFon/Rubik/blob/main/gifs/L_.gif)
**R (Right)**  | **L** | ![R](https://github.com/MixFon/Rubik/blob/main/gifs/R.gif)
**R' (Right)** | **;** | ![R'](https://github.com/MixFon/Rubik/blob/main/gifs/R_.gif)
**B (Back)**  | **C** | ![B](https://github.com/MixFon/Rubik/blob/main/gifs/B.gif)
**B' (Back)** | **V** | ![B'](https://github.com/MixFon/Rubik/blob/main/gifs/B_.gif)
**U (Up)**  | **D** | ![U](https://github.com/MixFon/Rubik/blob/main/gifs/U.gif)
**U' (Up)** | **F** | ![U'](https://github.com/MixFon/Rubik/blob/main/gifs/U_.gif)
**D (Down)**  | **J** | ![D](https://github.com/MixFon/Rubik/blob/main/gifs/D.gif)
**D' (Down)** | **K** | ![D'](https://github.com/MixFon/Rubik/blob/main/gifs/D_.gif)

Одинарная кавычка обозначает вращение грани против часовой стрелки. (F' L' R' B' U' D')

Цифра 2 обозначает двойное вращение грани по часовой стрелке. (F2 L2 R2 B2 U2 D2)



