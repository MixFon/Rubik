# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: widraugr <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2018/11/29 13:07:44 by widraugr          #+#    #+#              #
#    Updated: 2021/06/07 12:10:24 by mixfon           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = rubik

FILE_SWIFT = UIRubic/Color.swift\
			 UIRubic/Cube.swift\
			 UIRubic/Exception.swift\
			 UIRubic/Face.swift\
			 UIRubic/Flip.swift\
			 UIRubic/Solution.swift\
			 UIRubic/Turn.swift\
			 UIRubic/Axis.swift\
			 Rubik/main.swift\
			 Rubik/Rubik.swift

all : $(NAME)

$(NAME): $(FILE_SWIFT)
	swiftc $(FILE_SWIFT) -o $(NAME)

clean:
	/bin/rm -f $(NAME)
	
re: clean all 
