package filter;

import java.security.GeneralSecurityException;
import java.security.MessageDigest;


public class ICity365Util {

	public static String decode(String $txt){
	
		String $key = "icity365";
		String $chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-=_";
		String $ch = $txt.substring(0, 1);
		int $nh = $chars.indexOf($ch );
		String $mdKey = md5( $key + $ch );
		$mdKey = $mdKey.substring($nh % 8,$nh % 8+$nh % 8+7);//$nh % 8,$nh % 8+$nh % 8+7
		$txt = $txt.substring(1);
		char[] $txt2 = $txt.toCharArray();
		char[] $mdKey2 = $mdKey.toCharArray();
		char[] $chars2 = $chars.toCharArray();
		String $tmp = "";
		int $i = 0;
		int $j = 0;
		int $k = 0;
		for($i = 0; $i < $txt.length(); $i ++) {
			$k = $k == $mdKey.length() ? 0 : $k;
			$j = $chars.indexOf($txt2 [$i]) - $nh - (int)( $mdKey2 [$k ++] );
			while ( $j < 0 ){
				$j += 64;
			}
			$tmp += $chars2 [$j];
		}
		return new String(Base64.decode($tmp));
	}

	/**
	 * md5
	 * @return String
	 */
	public static String md5(String plainText){
		if(plainText == null)
			plainText = "";
		byte[] temp = plainText.getBytes();
		MessageDigest md;
		// 返回结果
		StringBuffer buffer = new StringBuffer();
		try {
			// 进行MD5散列
			md = MessageDigest.getInstance("md5");
			md.update(temp);
			temp = md.digest();
			// 将散列的结果转换为Hex字符串
			int i = 0;
			for (int offset = 0; offset < temp.length; offset++) {
				i = temp[offset];
				if (i < 0)
					i += 256;
				if (i < 16)
					buffer.append("0");
				buffer.append(Integer.toHexString(i));
			}
		} catch (GeneralSecurityException e) {
			e.printStackTrace();
		}
		// 返回
		return buffer.toString();
	}
}
