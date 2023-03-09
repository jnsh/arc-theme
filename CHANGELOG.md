*In compliance with the [GPL-3.0](https://opensource.org/licenses/GPL-3.0) license: I declare that this version of the program contains my modifications, which can be seen through the usual "git" mechanism.*  


2021-12  
Contributor(s):  
Joonas Henriksson  
>metacity-3: Increase rounded corner radiusFor identical corners with GTK decorations.Related: https://github.com/jnsh/arc-theme/issues/142  
>metacity-3: Add constant for border radius  
>metacity-3: Fix incorrect wm_icon_active_bg fallback color  
>metacity-3: Adjust titlebar vertical paddingApply titlebar vertical padding with button_border andtitle_vertical_pad, and don't use top and bottom title_border. Thisway there will always be sufficient padding regardless of thetitlebar font size. The minimum padding is based on GTK3 server sidedecorations from Mutter.  
>metacity-3: Do not apply button_border when there is no titlebarOthewise button_border will be applied in the top decoration border,making it unintentionally thick.Fixes: https://github.com/jnsh/arc-theme/issues/165  
>metacity-3: Don't round corners for tiled windowsRound corner looks odd when there's two adjacent tiled windows, andis inconsistent with GTK window decorations.  
- - - - - - - - - - - - - - - - - - - - - - - - - - - 


2021-09  
Contributor(s):  
a1346054  
>COPYING: Use license file from gnu.orgThey updated it to use https links and fix a redirect.Downloaded from:https://www.gnu.org/licenses/gpl-3.0.txt  
- - - - - - - - - - - - - - - - - - - - - - - - - - - 


2020-11  
Contributor(s):  
Joonas Henriksson  
>metacity: Add menu button iconFixes: https://github.com/jnsh/arc-theme/issues/69  
>metacity: Add shade/unshade button icon  
>metacity: Add stick/unstick button icons  
- - - - - - - - - - - - - - - - - - - - - - - - - - - 


2020-08  
Contributor(s):  
Joonas Henriksson  
>metacity: Use normal decorations on dialogsThis fixes missing close buttons and inconsistent font sizes on modaldialogs. Based on similar change to Mint-Y theme [1].[1] https://github.com/linuxmint/mint-y-theme/commit/136abcabe9bb66364fca57538b12a153377b6c65Fixes: https://github.com/jnsh/arc-theme/issues/22  
- - - - - - - - - - - - - - - - - - - - - - - - - - - 

