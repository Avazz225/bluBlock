import 'package:BluBlock/helpers/random_wait_time.dart';

String facebookBlockLogic = '''
function executeBlock(){
    var result = "BluBlockScriptResult - ";
    try{
    setTimeout(() => {
        const options_btn = document.getElementsByClassName('x1i10hfl xjbqb8w x1ejq31n xd10rxx x1sy0etr x17r0tee x972fbf xcfux6l x1qhh985 xm0m39n x1ypdohk xe8uvvx xdj266r x11i5rnm xat24cr x1mh8g0r xexx8yu x4uap5 x18d9i69 xkhd6sd x16tdsg8 x1hl2dhg xggy1nq x1o1ewxj x3x9cwd x1e5q0jg x13rtm0m x87ps6o x1lku1pv x1a2a7pz x9f619 x3nfvp2 xdt5ytf xl56j7k x1n2onr6 xh8yej3')
        try{
            options_btn[5].click();
            setTimeout(() => {
                try{
                    console.log("Y")
                    const block_btn = document.getElementsByClassName('x1i10hfl xjbqb8w x1ejq31n xd10rxx x1sy0etr x17r0tee x972fbf xcfux6l x1qhh985 xm0m39n xe8uvvx x1hl2dhg xggy1nq x1o1ewxj x3x9cwd x1e5q0jg x13rtm0m x87ps6o x1lku1pv x1a2a7pz xjyslct x9f619 x1ypdohk x78zum5 x1q0g3np x2lah0s xnqzcj9 x1gh759c x1i6fsjq xfvfia3 x1n2onr6 x16tdsg8 x1ja2u2z x6s0dn4 x1q8cg2c xnjli0 x1y1aw1k xwib8y2')[1]
                    var text = block_btn.innerText.toLowerCase();

                    if (text === "blockieren" || text === "block"){
                        try{
                            block_btn.click();
                            setTimeout(() => {
                                const block_executors = document.getElementsByClassName ('x1i10hfl xjbqb8w x1ejq31n xd10rxx x1sy0etr x17r0tee x972fbf xcfux6l x1qhh985 xm0m39n x1ypdohk xe8uvvx xdj266r x11i5rnm xat24cr x1mh8g0r xexx8yu x4uap5 x18d9i69 xkhd6sd x16tdsg8 x1hl2dhg xggy1nq x1o1ewxj x3x9cwd x1e5q0jg x13rtm0m x87ps6o x1lku1pv x1a2a7pz x9f619 x3nfvp2 xdt5ytf xl56j7k x1n2onr6 xh8yej3');
                                var block_executor = block_executors[9];
                                block_executor.click()
                                result += 'true';
                                console.log(result);
                                },${randomNumberGenerator(1000, 2000)});
                        } catch {
                            result += 'false';
                            console.log("Error while clicking block_executor");
                            console.log(result);
                        }
                    } else {
                        result += 'true';
                        console.log(result);
                    }
                } catch {
                  result += 'false';
                  console.log("Error while clicking block_btn");
                  console.log(result);
                }
            },${randomNumberGenerator(1000, 3000)});
        } catch {
            const btns = document.getElementsByClassName("x1n2onr6 x1ja2u2z x78zum5 x2lah0s xl56j7k x6s0dn4 xozqiw3 x1q0g3np xi112ho x17zwfj4 x585lrc x1403ito x972fbf xcfux6l x1qhh985 xm0m39n x9f619 xbxaen2 x1u72gb5 xtvsq51 x1fq8qgq")[0]
            try{
              if (btns.innerText.toLowerCase().includes("news")){
                result += 'true';
              } else {
                result += 'false';
                console.log("Error while clicking options_btn");
              }
             } catch {
                result += 'false';
                console.log("Error while clicking options_btn");
             }
        console.log(result);
        }
    },${randomNumberGenerator(1000, 1500)});
    } catch {
    result += 'false';
    console.log(result);
    }
}


window.onload = executeBlock();
''';

String facebookLoginLogic = '''
function checkLogin() {
    var result = "BluBlockScriptResult - ";
    setTimeout(() => {
        const loginBtn = document.querySelectorAll('[data-testid="royal_login_button"]')
        try {
            if (loginBtn.length === 1){
                result += 'false';
            } else {
                result += 'true';
            }
        } catch {
            result += 'true';
            console.log(result);
        }
        console.log(result);
    },${randomNumberGenerator(250, 750)});
}

window.onload = checkLogin();
''';