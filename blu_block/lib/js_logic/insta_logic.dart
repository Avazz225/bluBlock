import 'package:blu_block/helpers/random_wait_time.dart';

String instaBlockLogic = '''const options_btn = document.getElementsByClassName('x1i10hfl x972fbf xcfux6l x1qhh985 xm0m39n x9f619 xe8uvvx xdj266r x11i5rnm xat24cr x1mh8g0r x16tdsg8 x1hl2dhg xggy1nq x1a2a7pz x6s0dn4 xjbqb8w x1ejq31n xd10rxx x1sy0etr x17r0tee x1ypdohk x78zum5 xl56j7k x1y1aw1k x1sxyh0 xwib8y2 xurb0ha xcdnw81')[0];
options_btn.click()

setTimeout(() => {
	const block_btn = document.getElementsByClassName('xjbqb8w x1qhh985 xcfux6l xm0m39n x1yvgwvq x13fuv20 x178xt8z x1ypdohk xvs91rp x1evy7pa xdj266r x11i5rnm xat24cr x1mh8g0r x1wxaq2x x1iorvi4 x1sxyh0 xjkvuk6 xurb0ha x2b8uid x87ps6o xxymvpz xh8yej3 x52vrxo x4gyw5p xkmlbd1 x1xlr1w8')[0];
	var text = block_btn.textContent;
	if (text === "Nicht mehr blockieren"){
		return 'true';
	} else {
		block_btn.click();

		setTimeout(() => {
			const block_executor = document.getElementsByClassName ('xjbqb8w x1qhh985 xcfux6l xm0m39n x1yvgwvq x13fuv20 x178xt8z x1ypdohk xvs91rp x1evy7pa xdj266r x11i5rnm xat24cr x1mh8g0r x1wxaq2x x1iorvi4 x1sxyh0 xjkvuk6 xurb0ha x2b8uid x87ps6o xxymvpz xh8yej3 x52vrxo x4gyw5p xkmlbd1 x1xlr1w8')[3];
			block_executor.click()
      return 'true';
		},${randomNumberGenerator(250, 750)});
	}
},${randomNumberGenerator(250, 750)});
''';

String instaLoginLogic='''
function performLogin(){
    var result = ""
      try{
          const save = document.getElementsByClassName(' _acan _acap _acas _aj1- _ap30')[0]
          if(save.type === "submit"){
          result ='false'
          } else {
              save.click();
              result ='true'
          }
      } catch {
          result ='false'
      }
    return result;
}

performLogin()
''';