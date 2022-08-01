# test scoping. i.e., that correct a is used.
@ a, i
a = 999
!a+a
$ i = 0 $ i - 2 $ i :         #for loop start for(i=0; i<=2; i++)
[a:!1111 % @a a=8888 !a !~a !~0a !~2a]    #repeats 3 times
?                             #end for loop
!a
!~a
!~0a
