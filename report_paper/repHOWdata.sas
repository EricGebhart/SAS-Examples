proc format;
   value reac low-high = 'X'
              .        = ' ';
run;

data bptrial;
   input patient              $4.
      +1 sex                  $1.
      +1 drug                 $1.
      +1 dosage                3.
      +1 visitdate       mmddyy8.
      +1 (systolic diastolic) (3. +1)
         (fever nausea rash)  (1. +1);

   format fever nausea rash reac.;
cards;
1813 F A 400 01/08/91 109 73 . . . 1
1813 F A 400 01/15/91 109 73 . . . 2
1813 F A 400 01/22/91 107 73 . . . 3
1813 F A 400 01/29/91 109 73 . . . 4
1813 F A 400 02/05/91 100 74 . . . 5
1813 F A 400 02/12/91 114 73 . . . 6
1826 F B 200 01/09/91 125 89 . . . 1
1826 F B 200 01/16/91 124 89 . . . 2
1826 F B 200 01/23/91 123 86 . . . 3
1826 F B 200 01/30/91 122 86 . . . 4
1826 F B 200 02/06/91 120 90 1 . . 5
1826 F B 200 02/13/91 119 89 . 1 . 6
1839 M B 400 01/10/91 149 108 . . . 1
1839 M B 400 01/17/91 147 108 . . . 2
1839 M B 400 01/24/91 144 110 . . . 3
1839 M B 400 01/31/91 141 108 . . . 4
1839 M B 400 02/07/91 138 109 . 1 . 5
1839 M B 400 02/14/91 135 105 . . . 6
1852 F B 400 01/11/91 148 71 . . . 1
1852 F B 400 01/18/91 146 73 . . . 2
1852 F B 400 01/25/91 143 71 . 1 . 3
1852 F B 400 02/01/91 140 74 . . . 4
1852 F B 400 02/08/91 137 73 . . . 5
1852 F B 400 02/15/91 134 72 1 . . 6
1865 F B 400 01/07/91 111 61 . . . 1
1865 F B 400 01/14/91 109 63 . . . 2
1865 F B 400 01/21/91 120 61 . . . 3
1865 F B 400 01/28/91 117 62 . . . 4
1865 F B 400 02/04/91 110 63 . . . 5
1865 F B 400 02/11/91 114 60 . . . 6
1878 F A 200 01/08/91 118 86 . . . 1
1878 F A 200 01/15/91 118 82 . 1 . 2
1878 F A 200 01/22/91 107 86 1 . . 3
1878 F A 200 01/29/91 115 87 . . . 4
1878 F A 200 02/05/91 110 86 . . 1 5
1878 F A 200 02/12/91 109 87 . . . 6
1891 M B 400 01/09/91 103 101 . . . 1
1891 M B 400 01/16/91 103 101 . . . 2
1891 M B 400 01/23/91 100 101 . . . 3
1891 M B 400 01/30/91 105 98 . . . 4
1891 M B 400 02/06/91 108 101 . . . 5
1891 M B 400 02/13/91 101 101 . . . 6
1904 M A 400 01/10/91 124 102 . . . 1
1904 M A 400 01/17/91 123 104 1 . . 2
1904 M A 400 01/24/91 122 103 1 . . 3
1904 M A 400 01/31/91 121 102 . . . 4
1904 M A 400 02/07/91 120 106 . . . 5
1904 M A 400 02/14/91 118 104 . 1 . 6
1917 M B 200 01/11/91 102 85 . 1 . 1
1917 M B 200 01/18/91 100 85 . . . 2
1917 M B 200 01/25/91 100 85 . . . 3
1917 M B 200 02/01/91 115 85 . . . 4
1917 M B 200 02/08/91 113 84 . . . 5
1917 M B 200 02/15/91 100 85 . . . 6
1930 M A 200 01/07/91 106 64 . . . 1
1930 M A 200 01/14/91 100 66 1 . . 2
1930 M A 200 01/21/91 102 67 . . . 3
1930 M A 200 01/28/91 100 64 . . . 4
1930 M A 200 02/04/91 100 60 . . . 5
1930 M A 200 02/11/91 100 62 1 . 1 6
1943 F B 200 01/08/91 137 62 . . . 1
1943 F B 200 01/15/91 136 60 1 . 1 2
1943 F B 200 01/22/91 135 62 . . . 3
1943 F B 200 01/29/91 133 62 . . 1 4
1943 F B 200 02/05/91 132 60 . . . 5
1943 F B 200 02/12/91 131 62 . . . 6
1956 M B 400 01/09/91 149 92 . . . 1
1956 M B 400 01/16/91 147 93 . . . 2
1956 M B 400 01/23/91 144 92 . . 1 3
1956 M B 400 01/30/91 141 90 . . . 4
1956 M B 400 02/06/91 138 91 . . . 5
1956 M B 400 02/13/91 135 94 . . . 6
1969 F B 400 01/10/91 116 68 . . . 1
1969 F B 400 01/17/91 117 69 . . . 2
1969 F B 400 01/24/91 103 68 . . . 3
1969 F B 400 01/31/91 119 69 . . . 4
1969 F B 400 02/07/91 100 71 . . . 5
1969 F B 400 02/14/91 120 66 . . . 6
1982 M B 400 01/11/91 136 80 . 1 . 1
1982 M B 400 01/18/91 134 83 1 1 . 2
1982 M B 400 01/25/91 131 79 1 1 . 3
1982 M B 400 02/01/91 128 80 . . . 4
1982 M B 400 02/08/91 126 80 . . . 5
1982 M B 400 02/15/91 123 79 . . . 6
1995 M A 400 01/07/91 121 93 . . . 1
1995 M A 400 01/14/91 120 93 . . . 2
1995 M A 400 01/21/91 119 93 . . . 3
1995 M A 400 01/28/91 118 93 . . . 4
1995 M A 400 02/04/91 117 93 . . . 5
1995 M A 400 02/11/91 115 96 . . . 6
2008 M B 200 01/08/91 130 62 1 . . 1
2008 M B 200 01/15/91 129 62 . . . 2
2008 M B 200 01/22/91 128 62 . . . 3
2008 M B 200 01/29/91 127 64 . . . 4
2008 M B 200 02/05/91 125 60 1 1 . 5
2008 M B 200 02/12/91 124 62 . . . 6
2021 F A 400 01/09/91 112 106 . . . 1
2021 F A 400 01/16/91 113 105 . . . 2
2021 F A 400 01/23/91 104 106 . 1 . 3
2021 F A 400 01/30/91 102 106 . . . 4
2021 F A 400 02/06/91 106 107 . 1 . 5
2021 F A 400 02/13/91 122 103 . . . 6
2034 F B 200 01/10/91 111 69 . . . 1
2034 F B 200 01/17/91 101 70 . . . 2
2034 F B 200 01/24/91 100 72 . . . 3
2034 F B 200 01/31/91 109 68 . . . 4
2034 F B 200 02/07/91 111 70 . . . 5
2034 F B 200 02/14/91 100 69 1 . . 6
2047 M A 400 01/11/91 134 96 . . . 1
2047 M A 400 01/18/91 133 96 . . . 2
2047 M A 400 01/25/91 132 95 . . . 3
2047 M A 400 02/01/91 130 97 . . . 4
2047 M A 400 02/08/91 129 96 . . . 5
2047 M A 400 02/15/91 128 95 . . . 6
2060 M A 200 01/07/91 117 90 . . . 1
2060 M A 200 01/14/91 113 92 . . . 2
2060 M A 200 01/21/91 114 90 1 . . 3
2060 M A 200 01/28/91 105 89 . . . 4
2060 M A 200 02/04/91 103 90 . . . 5
2060 M A 200 02/11/91 118 90 1 . 1 6
2073 M B 200 01/08/91 105 77 . . . 1
2073 M B 200 01/15/91 114 76 . . . 2
2073 M B 200 01/22/91 100 79 . . . 3
2073 M B 200 01/29/91 107 77 . . . 4
2073 M B 200 02/05/91 100 77 . . . 5
2073 M B 200 02/12/91 110 75 . . . 6
2086 M A 400 01/09/91 148 79 . . . 1
2086 M A 400 01/16/91 147 76 . 1 . 2
2086 M A 400 01/23/91 146 78 1 1 . 3
2086 M A 400 01/30/91 144 80 . . . 4
2086 M A 400 02/06/91 143 75 . 1 1 5
2086 M A 400 02/13/91 141 73 . 1 . 6
2099 F B 200 01/10/91 118 77 . 1 1 1
2099 F B 200 01/17/91 112 77 . . . 2
2099 F B 200 01/24/91 117 78 . . . 3
2099 F B 200 01/31/91 123 77 . . . 4
2099 F B 200 02/07/91 125 79 . . . 5
2099 F B 200 02/14/91 101 74 . . . 6
2112 F A 200 01/11/91 141 63 . . . 1
2112 F A 200 01/18/91 150 62 . 1 . 2
2112 F A 200 01/25/91 143 64 1 . . 3
2112 F A 200 02/01/91 146 63 . 1 . 4
2112 F A 200 02/08/91 147 62 1 1 . 5
2112 F A 200 02/15/91 114 64 1 1 . 6
2125 M A 200 01/07/91 110 102 1 . . 1
2125 M A 200 01/14/91 100 104 . 1 . 2
2125 M A 200 01/21/91 100 101 1 . . 3
2125 M A 200 01/28/91 116 101 1 . . 4
2125 M A 200 02/04/91 125 103 . . . 5
2125 M A 200 02/11/91 110 102 1 1 . 6
2138 F B 400 01/08/91 149 101 1 . . 1
2138 F B 400 01/15/91 147 96 1 1 . 2
2138 F B 400 01/22/91 144 101 1 1 1 3
2138 F B 400 01/29/91 141 101 1 1 1 4
2138 F B 400 02/05/91 138 101 1 1 . 5
2138 F B 400 02/12/91 135 102 1 . . 6
2151 M A 400 01/09/91 114 100 . 1 . 1
2151 M A 400 01/16/91 100 99 1 1 . 2
2151 M A 400 01/23/91 109 101 1 1 . 3
2151 M A 400 01/30/91 106 97 1 1 . 4
2151 M A 400 02/06/91 116 102 1 . . 5
2151 M A 400 02/13/91 110 100 1 1 . 6
2164 F B 200 01/10/91 130 82 1 . . 1
2164 F B 200 01/17/91 129 83 1 1 . 2
2164 F B 200 01/24/91 128 82 . . . 3
2164 F B 200 01/31/91 127 81 . . . 4
2164 F B 200 02/07/91 125 82 1 . 1 5
2164 F B 200 02/14/91 124 82 . . . 6
2177 M B 400 01/11/91 136 94 1 1 . 1
2177 M B 400 01/18/91 134 94 1 1 1 2
2177 M B 400 01/25/91 131 93 1 . . 3
2177 M B 400 02/01/91 128 91 . . . 4
2177 M B 400 02/08/91 126 93 1 . . 5
2177 M B 400 02/15/91 123 94 . 1 . 6
2190 F B 200 01/07/91 110 66 1 . . 1
2190 F B 200 01/14/91 116 67 1 1 . 2
2190 F B 200 01/21/91 119 66 1 . . 3
2190 F B 200 01/28/91 110 67 1 1 . 4
2190 F B 200 02/04/91 116 65 . 1 1 5
2190 F B 200 02/11/91 100 63 1 1 . 6
2203 F B 400 01/08/91 102 94 . 1 . 1
2203 F B 400 01/15/91 107 92 1 . 1 2
2203 F B 400 01/22/91 109 93 . . . 3
2203 F B 400 01/29/91 100 93 1 1 . 4
2203 F B 400 02/05/91 110 97 1 1 1 5
2203 F B 400 02/12/91 100 95 1 . 1 6
2216 M A 200 01/09/91 133 81 . 1 . 1
2216 M A 200 01/16/91 133 81 1 . . 2
2216 M A 200 01/23/91 137 81 . 1 . 3
2216 M A 200 01/30/91 143 82 1 . . 4
2216 M A 200 02/06/91 144 80 1 . . 5
2216 M A 200 02/13/91 121 80 . . . 6
2229 M B 200 01/10/91 127 100 1 1 . 1
2229 M B 200 01/17/91 126 98 . . . 2
2229 M B 200 01/24/91 125 100 . 1 . 3
2229 M B 200 01/31/91 124 100 . . . 4
2229 M B 200 02/07/91 122 99 1 1 . 5
2229 M B 200 02/14/91 121 102 1 . . 6
2242 F A 200 01/11/91 139 96 . . . 1
2242 F A 200 01/18/91 130 96 . . . 2
2242 F A 200 01/25/91 150 95 . . . 3
2242 F A 200 02/01/91 148 96 . . . 4
2242 F A 200 02/08/91 144 94 . . . 5
2242 F A 200 02/15/91 142 96 . . . 6
2255 F A 400 01/07/91 114 65 . . . 1
2255 F A 400 01/14/91 113 63 . . . 2
2255 F A 400 01/21/91 122 65 . . . 3
2255 F A 400 01/28/91 111 65 . . . 4
2255 F A 400 02/04/91 126 66 . . . 5
2255 F A 400 02/11/91 106 65 . . . 6
2268 M B 200 01/08/91 112 74 . . . 1
2268 M B 200 01/15/91 107 76 . 1 . 2
2268 M B 200 01/22/91 114 73 1 1 . 3
2268 M B 200 01/29/91 102 75 . . . 4
2268 M B 200 02/05/91 110 71 . 1 1 5
2268 M B 200 02/12/91 100 74 . . . 6
2281 F A 400 01/09/91 140 63 1 . 1 1
2281 F A 400 01/16/91 139 63 1 1 . 2
2281 F A 400 01/23/91 138 61 . . 1 3
2281 F A 400 01/30/91 136 61 . . . 4
2281 F A 400 02/06/91 135 64 1 1 . 5
2281 F A 400 02/13/91 133 62 1 1 1 6
2294 M A 200 01/10/91 122 96 1 1 . 1
2294 M A 200 01/17/91 128 96 1 1 . 2
2294 M A 200 01/24/91 116 94 . 1 1 3
2294 M A 200 01/31/91 135 97 1 . . 4
2294 M A 200 02/07/91 119 95 1 1 1 5
2294 M A 200 02/14/91 112 95 . 1 . 6
2307 M B 200 01/11/91 101 80 . 1 1 1
2307 M B 200 01/18/91 105 80 . . . 2
2307 M B 200 01/25/91 119 78 1 1 . 3
2307 M B 200 02/01/91 109 80 . . . 4
2307 M B 200 02/08/91 103 80 1 1 1 5
2307 M B 200 02/15/91 100 82 1 1 . 6
run;