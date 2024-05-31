import 'package:BluBlock/helpers/random_wait_time.dart';

String instaBlockLogic = '''
function executeBlock(){
  var result = "BluBlockScriptResult - ";
  try{
    setTimeout(() => {
      const options_btn = document.getElementsByClassName('x1i10hfl x972fbf xcfux6l x1qhh985 xm0m39n x9f619 xe8uvvx xdj266r x11i5rnm xat24cr x1mh8g0r x16tdsg8 x1hl2dhg xggy1nq x1a2a7pz x6s0dn4 xjbqb8w x1ejq31n xd10rxx x1sy0etr x17r0tee x1ypdohk x78zum5 xl56j7k x1y1aw1k x1sxyh0 xwib8y2 xurb0ha xcdnw81')[0];
      try{
        options_btn.click()
        setTimeout(() => {
          try{
            const block_btn = document.getElementsByClassName('xjbqb8w x1qhh985 xcfux6l xm0m39n x1yvgwvq x13fuv20 x178xt8z x1ypdohk xvs91rp x1evy7pa xdj266r x11i5rnm xat24cr x1mh8g0r x1wxaq2x x1iorvi4 x1sxyh0 xjkvuk6 xurb0ha x2b8uid x87ps6o xxymvpz xh8yej3 x52vrxo x4gyw5p xkmlbd1 x1xlr1w8')[0];
            var text = block_btn.textContent;
            if (text === "Nicht mehr blockieren" || text === "Unblock"){
              result += 'true';
              console.log(result);
            } else {
              try{
                block_btn.click();
                setTimeout(() => {
                  const block_executors = document.getElementsByClassName ('xjbqb8w x1qhh985 xcfux6l xm0m39n x1yvgwvq x13fuv20 x178xt8z x1ypdohk xvs91rp x1evy7pa xdj266r x11i5rnm xat24cr x1mh8g0r x1wxaq2x x1iorvi4 x1sxyh0 xjkvuk6 xurb0ha x2b8uid x87ps6o xxymvpz xh8yej3 x52vrxo x4gyw5p xkmlbd1 x1xlr1w8');
                  var block_executor = block_executors[block_executors.length-1];
                  block_executor.click()
                  result += 'true';
                  setTimeout(() => {
                    const btns = document.getElementsByClassName('xjbqb8w x1qhh985 xcfux6l xm0m39n x1yvgwvq x13fuv20 x178xt8z x1ypdohk xvs91rp x1evy7pa xdj266r x11i5rnm xat24cr x1mh8g0r x1wxaq2x x1iorvi4 x1sxyh0 xjkvuk6 xurb0ha x2b8uid x87ps6o xxymvpz xh8yej3 x52vrxo x4gyw5p x5n08af')
                    var btn = btns[btns.length-1];
                    //btn.click();
                    setTimeout(() => {
                      console.log(result);
                    },${randomNumberGenerator(3500, 5000)});
                  },${randomNumberGenerator(1000, 1500)});
                },${randomNumberGenerator(1000, 2000)});
              } catch {
                result += 'false';
                console.log("Error while clicking block_executor");
                console.log(result);
              }
            }
          } catch {
            result += 'false';
            console.log("Error while clicking block_btn");
            console.log(result);
          }
        },${randomNumberGenerator(1000, 1250)});
      } catch {
        result += 'false';
        console.log("Error while clicking options_btn");
        console.log(result);
      }
    },${randomNumberGenerator(1250, 1500)});
  } catch {
    result += 'false';
    console.log(result);
  }
}


window.onload = executeBlock();
''';

String instaLoginLogic='''
function performLogin(callback) {
    var result = "BluBlockScriptResult - ";
    try {
        const save = document.getElementsByClassName(' _acan _acap _acas _aj1- _ap30')[0];
        if (save.type === "submit") {
            result += 'false';
        } else {
            save.click();
            result += 'true';
        }
    } catch {
        result += 'false';
    }
    console.log(result);
}

setTimeout(() => {
    performLogin(function(result) {
        result;
    });
}, ${randomNumberGenerator(250, 500)});
''';


String instaLogoutLogic='''
''';