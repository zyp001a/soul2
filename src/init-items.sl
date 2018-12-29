itemsc := classDefx(defmain, "Items", _, {
 itemsType: cptc
})
itemslimitedc := classDefx(defmain, "ItemsLimited", [itemsc], {
 itemsLimitedLength: uintc
})
arrc := curryDefx(defmain, "Arr", itemsc)
arrc.ctype = T##ARR
staticarrc := curryDefx(defmain, "StaticArr", arrc)

arrbytec := itemDefx(arrc, bytec)
dicc := curryDefx(defmain, "Dic", itemsc)
dicc.ctype = T##DIC

/////8 advanced type init: string, enum, unlimited number...
strc := curryDefx(defmain, "Str", valc)
strc.ctype = T##STR


arrstrc := itemDefx(arrc, strc)
dicstrc := itemDefx(dicc, strc)
dicuintc := itemDefx(dicc, uintc)
dicclassc := itemDefx(dicc, classc)
arrclassc := itemDefx(arrc, classc)


