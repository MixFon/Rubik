# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: widraugr <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2018/11/29 13:07:44 by widraugr          #+#    #+#              #
#    Updated: 2021/06/07 12:43:25 by mixfon           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = rubik_cube

FILE_SWIFT = Rubik/main.swift\
			 Rubik/Rubik.swift\
			 UIRubik/Axis.swift\
			 UIRubik/Color.swift\
			 UIRubik/Coodinate.swift\
			 UIRubik/Cube.swift\
			 UIRubik/Exception.swift\
			 UIRubik/Face.swift\
			 UIRubik/Flip.swift\
			 UIRubik/Solution.swift\
			 UIRubik/Turn.swift

all : $(NAME)

$(NAME): $(FILE_SWIFT)
	swiftc $(FILE_SWIFT) -o $(NAME)

clean:
	/bin/rm -f $(NAME)
	
re: clean all 
