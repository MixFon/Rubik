# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: widraugr <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2018/11/29 13:07:44 by widraugr          #+#    #+#              #
#    Updated: 2021/06/05 20:29:12 by mixfon           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = rubik

FILE_SWIFT = UIRubic/UIRubic/Color.swift\
			 UIRubic/UIRubic/Cube.swift\
			 UIRubic/UIRubic/Exception.swift\
			 UIRubic/UIRubic/Face.swift\
			 UIRubic/UIRubic/Flip.swift\
			 UIRubic/UIRubic/Solution.swift\
			 UIRubic/UIRubic/Turn.swift\
			 UIRubic/UIRubic/Axis.swift\
			 UIRubic/Rubik/main.swift\
			 UIRubic/Rubik/Rubik.swift

all : $(NAME)

$(NAME): $(FILE_SWIFT)
	swiftc $(FILE_SWIFT) -o $(NAME)

clean:
	/bin/rm -f $(NAME)
	
re: clean all 
