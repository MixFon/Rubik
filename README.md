# Rubik
В данном проекте необходимо написать программу, собирающую Кубик Рубика.

На вход программе подается последовательность поворотов граней, которые запутывают кубик. Программа выдает последовательность поворотов граней, которые приведут к собранному состоянию кубика.

## Использование

### Консольная версия
Для работы с консольной версией необходимо:
1. Клонировать ветку main
2. Перейти в папку с исходным кодом
3. Собрать проект (make)
4. Запустить программу, в качестве параметра передать строку с последовательностью поворотов граней.
    

   
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

        git clone https://github.com/MixFon/Rubik.git
        cd Rubik
        open UIRubik.xcodeproj
        
## Вращения
* F (Front) - вращение передней синей грани по часовой стрелке.
* L (Left) - вращение левой оранжевой грани по часовой стрелке.
* R (Right) - вращение правой красной грани по часовой стрелке.
* B (Back) - вращение задней зеленой грани по часовой стрелке.
* U (Up) - вращение верхней желтой грани по часовой стрелке.
* D (Down) - вращение нижней белой грани по часовой стрелке.

Одинарная кавычка обозначает вращение грани против часовой стрелки. (F' L' R' B' U' D')

Цифра 2 обозначает двойное вращение грани по часовой стрелке. (F2 L2 R2 B2 U2 D2)

#### Грань F

![F](https://github.com/MixFon/Rubik/blob/main/gifs/F.gif)

![F'](https://github.com/MixFon/Rubik/blob/main/gifs/F_.gif)

#### Грань L

![L](https://github.com/MixFon/Rubik/blob/main/gifs/L.gif)

![L'](https://github.com/MixFon/Rubik/blob/main/gifs/L_.gif)

#### Грань R

![R](https://github.com/MixFon/Rubik/blob/main/gifs/R.gif)

![R'](https://github.com/MixFon/Rubik/blob/main/gifs/R_.gif)

#### Грань B

![B](https://github.com/MixFon/Rubik/blob/main/gifs/B.gif)

![B'](https://github.com/MixFon/Rubik/blob/main/gifs/B_.gif)

#### Грань U

![U](https://github.com/MixFon/Rubik/blob/main/gifs/U.gif)

![U'](https://github.com/MixFon/Rubik/blob/main/gifs/U_.gif)
    


