open Core

let%expect_test "iteration_1" =
  let program = Helper.parse {|
    int main()
    {
      return 0;
    }
  |} in
  let s = Minicc.Ast.show_program program in
  printf "%s" s;
  [%expect {|
    { Ast.var_decls = [];
      func_decls =
      [{ Ast.ret_typ = Ast.TyInt; name = "main"; locals = [];
         body = [(Ast.Return (Ast.IntLit 0))] }
        ]
      }
  |}]

let%expect_test "iteration_2" =
  let program = Helper.parse {|
    int main()
    {
      int i = 0;
      return i;
    }
  |} in
  let s = Minicc.Ast.show_program program in
  printf "%s" s;
  [%expect {|
    { Ast.var_decls = [];
      func_decls =
      [{ Ast.ret_typ = Ast.TyInt; name = "main";
         locals =
         [{ Ast.bind_type = Ast.TyInt; bind_name = "i";
            initial_value = (Some (Ast.IntLit 0)) }
           ];
         body = [(Ast.Return (Ast.Ident { Ast.literal = "i" }))] }
        ]
      }
  |}]

let%expect_test "iteration_3" =
  let program = Helper.parse {|
    int main()
    {
      int i = 90;
      i = 0;
      return i;
    }
  |} in
  let s = Minicc.Ast.show_program program in
  printf "%s" s;
  [%expect {|
    { Ast.var_decls = [];
      func_decls =
      [{ Ast.ret_typ = Ast.TyInt; name = "main";
         locals =
         [{ Ast.bind_type = Ast.TyInt; bind_name = "i";
            initial_value = (Some (Ast.IntLit 90)) }
           ];
         body =
         [(Ast.Assign
             { Ast.assign_left = (Ast.Ident { Ast.literal = "i" });
               assign_right = (Ast.IntLit 0) });
           (Ast.Return (Ast.Ident { Ast.literal = "i" }))]
         }
        ]
      }
  |}]

let%expect_test "iteration_5" =
  let program = Helper.parse {|
    int main()
    {
      int i = 0;
      i = i + 3;
      i = i - 1;
      i = i / 2;
      i = i * 4;
      return i;
    }
  |} in
  let s = Minicc.Ast.show_program program in
  printf "%s" s;
  [%expect {|
    { Ast.var_decls = [];
      func_decls =
      [{ Ast.ret_typ = Ast.TyInt; name = "main";
         locals =
         [{ Ast.bind_type = Ast.TyInt; bind_name = "i";
            initial_value = (Some (Ast.IntLit 0)) }
           ];
         body =
         [(Ast.Assign
             { Ast.assign_left = (Ast.Ident { Ast.literal = "i" });
               assign_right =
               (Ast.Binop
                  { Ast.binop_type = Ast.Add;
                    binop_left = (Ast.Ident { Ast.literal = "i" });
                    binop_right = (Ast.IntLit 3) })
               });
           (Ast.Assign
              { Ast.assign_left = (Ast.Ident { Ast.literal = "i" });
                assign_right =
                (Ast.Binop
                   { Ast.binop_type = Ast.Sub;
                     binop_left = (Ast.Ident { Ast.literal = "i" });
                     binop_right = (Ast.IntLit 1) })
                });
           (Ast.Assign
              { Ast.assign_left = (Ast.Ident { Ast.literal = "i" });
                assign_right =
                (Ast.Binop
                   { Ast.binop_type = Ast.Div;
                     binop_left = (Ast.Ident { Ast.literal = "i" });
                     binop_right = (Ast.IntLit 2) })
                });
           (Ast.Assign
              { Ast.assign_left = (Ast.Ident { Ast.literal = "i" });
                assign_right =
                (Ast.Binop
                   { Ast.binop_type = Ast.Mul;
                     binop_left = (Ast.Ident { Ast.literal = "i" });
                     binop_right = (Ast.IntLit 4) })
                });
           (Ast.Return (Ast.Ident { Ast.literal = "i" }))]
         }
        ]
      }
  |}]