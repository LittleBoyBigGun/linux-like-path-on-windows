BEGIN{
  FS="|"
  print "" 
  n0 = 5;
  n1 = 20;
  n2 = 60;
  n3 = 20;
}
{
  arr[trim($4)][trim($2)] = $2$3$4 
}
END{
  #printf("%-"n0"d%-"n1"s%-"n2"s%-"n3"s\n", NR, trim($2), trim($3), trim($4));

  if (choice == 1){
    printf("%-"n0"s%-"n1"s%-"n2"s%-"n3"s\n", "id", "name", "desc", "category");
    bar(n0+n1+n2+n3);
    PROCINFO["sorted-in"] = "sort_ind_asc" #"@ind_str_asc"
    #多列排序例子
    asort(arr)
    count = 1
    for (rr in arr) {
      asort(arr[rr])
      for (kk in arr[rr]) {
        printf("%-"n0"s%s\n", count++, arr[rr][kk])
      }
    }
    bar(n0+n1+n2+n3);
  } else if (choice == 2) {
    #show category
    for (hh in arr){
      catearr[hh] = hh
    }
    PROCINFO["sorted-in"] = "sort_ind_asc" #"@ind_str_asc"
    asorti(catearr)
    print "all categories are:"
    print "************"
    for(pp in catearr) 
      print catearr[pp]
    print "************"
  }
}

#i1 i2 为二维数组的最左边的 index
#v1 v2 为二维数组的某个 index 后面的所有元素， 为一个数组
function sort_ind_asc(i1, v1, i2, v2) {
  
  if (i1 > i2) {
    return 1 
  } else {
    return -1
  }
}

function trim(str) {
	sub("^[ ]*", "", str);
    sub("[ ]*$", "", str);
    return str
}

function bar(count){
  i = 0;
  while(i < count) {
    printf ("%s","*");
    i++;
  }
  print ""
}

