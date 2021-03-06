# 第一次自幹CPU就上手

## 動機

* 主因:
    不知道為何撞到腦袋，在大四下學期放棄了中央軟工所，然後在工作兩年後覺得**應該**到研究所補足一些做研究的訓練。並且~~很驚恐的在八月底~~發現，通常十月是研究所推甄的日子，由於在學成績低空飛過~~慘不忍睹~~，只好用作品補足以證明大學四年沒有白念~~白混~~。所以九月工作時間之餘，剩下時間全都拿來衝刺作品，剛好之前手癢買了《自己動手寫CPU》這本書，就按照書本從頭實作一遍MIPS指令集的CPU，也當作對大學課程的複習(~~其實是怕推甄沒上還要考試先念起來放~~)
* 次因:
    某天(2017/10/05)在看 jserv 的直播《現代處理器原理和關鍵特徵 (下)》的時候，jserv 在解釋一些處理器觀念後在聊一些計算機組織課程的話題，突然說一句「做不到那個強度就不是本科」。所以為了當一名~~合格~~的資工系本科畢業學生，只好找本書來參考，寫一個軟核心的CPU，並且嘗試porting一個作業系統到FPGA板子上。
* 不是要黑 jserv，只是「做不到那個強度就不是本科」這句話讓我想認真挑戰能不能自幹一個基礎的MIPS(~~謎之聲:你只是想玩梗吧XD~~)

## 每篇實作心得連結

雖然是照著別人的東西再做一遍，但還是會踩到地雷，所以每一篇都會特別紀錄哪些觀念花比較多時間理解。

1. [第一次用pipeline就上手及CPU第一條指令ori](CH1/doc/ReadMe.md)
2. [身為一個CPU，會邏輯跟位移運算也是很正常的](CH2/doc/ReadMe.md)
3. [~~至高~~移動指令](CH3/doc/ReadMe.md)
4. 算術要做什麼？有沒有空？可以來實做嗎？
    1. [簡單算術實做](CH4_1/doc/ReadMe.md)
    2. [在單一週期內尋求暫停管線是否搞錯了什麼？](CH4_2/doc/ReadMe.md)
    3. [給我一個零點，除法可以舉起(raise)一個例外](CH4_3/doc/ReadMe.md)
5. [跳躍吧！分支](CH5/doc/ReadMe.md)
6. 不能操作記憶體的CPU沒有使用的必要
    1. [S/L大法](CH6_1/doc/ReadMe.md)
    2. [S/L大法2 - RMW](CH6_2/doc/ReadMe.md)
7. [Coprocessor 是什麼，能吃嗎？](CH7/doc/ReadMe.md)
8. [例外與中斷的慘烈修羅場](CH8/doc/ReadMe.md)
9. [是匯流排，我在CPU裡加了匯流排](CH9/doc/ReadMe.md)

## 疑惑

照著書本實作還是會有疑惑，所以在這底下補上(如果已弄懂會在底下更新)

- [x] **Q**: AluOp到底是怎麼決定的？《自己動手寫CPU》中只有提到每個指令的opcode，卻沒有特別說明，AluOp如何產生。(最雷的是《計算機組織與設計》上說詳細請參考附錄D，結果附錄只有A, B, F) - *2018/09/02 新增*
    **A**:
    1. 重讀《計算機組織與設計》關於AluOp的設計才弄懂。因為MIPS32的功能設計有`AND, OR, add, subtract, set on less than, NOR`，至少需要3 bits才能表示。加上function field的5 bits，總共8 bits。這應該就是《自己動手寫CPU》的 AluOp 共8 bits的原因，至於function field的編碼不知道是作者遵守OpenMIPS的規則還是自己編的。 - *2018/09/04 更新*
    2. 趁開學日跑去請教(~~煩~~)以前的教授這個問題，AluOp 有幾個 bits 是在 Instruction Set Architecture(ISA) 決定的時候就決定好的，而 MIPS32 在 ISA 決定好的時候，AluOp 最少需要 8 bits。覺得基礎忘光了很慚愧QQ - *2018/09/10 更新*

- [x] **Q**: 好奇《自己動手寫CPU》的作者在page.7-41的程式碼，為什麼不要在前面的第二段就決定`stallreq`，反而還要特別弄一個變數`stallreq_for_madd_msub`出來？ - *2018/09/06 新增*
    ```Verilog HDL
    // 第三段: 暫停管線
    always @ (*) begin
        stallreq = stallreq_for_madd_msub;
    end
    ```
    **A**: 實作到後面章節回頭看才發現作者的做法比較好，因為加入除法後的程式變成以下這樣
    ```Verilog HDL
    always @ (*) begin
        stop_all_req_from_ex = stop_all_req_for_madd_msub || stop_all_req_for_div;
    end
    ```
    這樣的做法可以把累加跟除法的暫停分開實作，最後在同一個地方彙整，不用在整個程式放滿`stop_all_req_from_ex <= stop_all_req_for_madd_msub || stop_all_req_for_div;`，在程式的維護上會比較方便 - *2018/09/15 更新*

## 參考書本

* [自己動手寫CPU](https://www.books.com.tw/products/0010676982)
* [計算機組織與設計](https://www.books.com.tw/products/0010677129)
* [作者微博 - 自己动手写CPU系列](https://blog.csdn.net/leishangwen/article/category/5723475/3)