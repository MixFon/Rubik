# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: widraugr <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2018/11/29 13:07:44 by widraugr          #+#    #+#              #
#    Updated: 2021/06/07 12:27:16 by mixfon           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = rubik_cube

FILE_SWIFT = Rubik/main.swift\
			 Rubik/Rubik.swift\
			 UIRubic/Axis.swift\
			 UIRubic/Color.swift\
			 UIRubic/Coodinate.swift\
			 UIRubic/Cube.swift\
			 UIRubic/Exception.swift\
			 UIRubic/Face.swift\
			 UIRubic/Flip.swift\
			 UIRubic/Solution.swift\
			 UIRubic/Turn.swift

all : $(NAME)

$(NAME): $(FILE_SWIFT)
	swiftc $(FILE_SWIFT) -o $(NAME)

clean:
	/bin/rm -f $(NAME)
	
re: clean all 
