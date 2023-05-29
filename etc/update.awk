BEGIN{


  w1=20;
  w2=60
  w3=20
}

BEGINFILE{
   #文件为空
   STATUS[get_name(FILENAME)] = "aborted";
   REASON[get_name(FILENAME)] = "empty";
}
  
#文件非空
FNR <=3{
  if (FNR == 1) {
    rec_name = process("filename", w1)
    name_ind = trim($3)
  } else if (FNR == 2) {
    rec_desc = process("description", w2)
  } else if (FNR == 3) {
    cate_ind = trim($3)
    rec_cate = process("category", w3)
    record = rec_name rec_desc rec_cate 
    RECORDS[cate_ind][name_ind] = record
  }
}


ENDFILE{
}


END{

  printf("%-20s%-10s%-30s\n", "name", "status", "reason")
  bar(60)
  PROCINFO["sorted_in" ] = "@ind_str_asc"
  for (n in STATUS){
    printf("%-20s%-10s%-30s\n", n, STATUS[n], REASON[n])
  }
  bar(60)

  #parse result output to file
  asort(RECORDS)
  for (nn in RECORDS){
    asort(RECORDS[nn])
    for (mm in RECORDS[nn]){
      print RECORDS[nn][mm] >> savefile 
    } 
  }
}


function get_name(p) {
   match(p, /\\([^\\]+)\.cmd$/, get_name_ret) 
   #return substr(p, RSTART+1, RLENGTH-4)
   return get_name_ret[1] 
}

function process(coloum_name, width){
  process_name = get_name(FILENAME);

  if (trim($2) != coloum_name) {
    STATUS[process_name] = "aborted";
    REASON[process_name] = "bad "coloum_name;
    nextfile;
  }

  STATUS[process_name] = "done" 
  REASON[process_name] = "ok"

  process_ret = append_blank(trim($3), width)
  if (trim($2) == "filename") {
    return "|" process_ret 
  }
  return process_ret
}

function trim(str) {
	sub("^[ ]*", "", str);
    sub("[ ]*$", "", str);
    return str;
}


function append_blank(str, num){
  tmp=""
  for (i=0; i< num - length(str); i++) {
    tmp=tmp" "
  } 
  return str tmp "|";
}

function bar(num) {
  for (i=0; i<num;i++){
    printf("%-1s", "*")
  }
  print ""
}


