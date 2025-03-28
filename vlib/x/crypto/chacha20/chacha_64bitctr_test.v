module chacha20

import encoding.hex

struct Test64BitXorKeyStream {
	counter         u64
	key             []u8
	nonce           []u8
	msgs            [][]u8
	expected_output [][]u8
}

const ch20_64bitctr_xor_key_stream_testdata = [
	Test64BitXorKeyStream{
		counter:         u64(0)
		key:             [u8(225), 2, 1, 178, 238, 127, 187, 188, 27, 237, 18, 62, 181, 65, 67,
			152, 13, 247, 147, 148, 101, 220, 185, 120, 234, 58, 144, 173, 3, 218, 193, 130]
		nonce:           [u8(153), 221, 244, 134, 99, 135, 243, 247]
		msgs:            [[u8(231), 121, 9, 28],
			[u8(178), 221, 62, 9, 153, 189, 106, 12, 117, 47, 192, 81, 65, 112, 85, 57],
			[u8(155), 202, 56, 16], [u8(227), 47, 226, 137], [u8(162), 77, 218, 52],
			[u8(42), 250, 184, 196],
			[u8(2), 129, 13, 136, 6, 12, 235, 183, 38, 178, 151, 243, 27,
				88, 97, 40],
			[u8(248), 170, 168, 206], [u8(181), 220, 223, 139],
			[u8(95), 108, 201, 227], [u8(38), 221, 147, 230],
			[u8(98), 229, 5, 130, 13, 103, 248, 159, 240, 246, 56, 119, 160, 130, 82, 222],
			'hello hello hello'.bytes(), 'me me me'.bytes()]
		expected_output: [[u8(14), 153, 137, 166],
			[u8(132), 202, 57, 24, 78, 201, 133, 147, 175, 207, 224, 48, 197, 188, 230, 120],
			[u8(243), 129, 27, 186], [u8(103), 184, 201, 233],
			[u8(99), 236, 76, 148], [u8(12), 206, 236, 195],
			[u8(72), 82, 44, 56, 164, 43, 98, 29,
				182, 98, 48, 235, 189, 181, 216, 152],
			[u8(229), 19, 86, 45], [u8(109), 199, 143, 155], [u8(2), 33, 39, 189],
			[u8(170), 82, 98, 126],
			[u8(29), 236, 210, 171, 117, 132, 115, 18, 7, 18, 248, 97, 165,
				21, 147, 241],
			[u8(211), 17, 84, 145, 207, 106, 145, 1, 245, 189, 8, 45, 71, 248, 44, 15, 201],
			[u8(124), 195, 175, 137, 33, 119, 236, 120]]
	},
	Test64BitXorKeyStream{
		counter:         u64(0)
		key:             [u8(225), 2, 1, 178, 238, 127, 187, 188, 27, 237, 18, 62, 181, 65, 67,
			152, 13, 247, 147, 148, 101, 220, 185, 120, 234, 58, 144, 173, 3, 218, 193, 130]
		nonce:           [u8(255), 255, 255, 255, 255, 255, 255, 255]
		msgs:            [[u8(231), 121, 9, 28],
			[u8(178), 221, 62, 9, 153, 189, 106, 12, 117, 47, 192, 81, 65, 112, 85, 57],
			[u8(155), 202, 56, 16], [u8(227), 47, 226, 137], [u8(162), 77, 218, 52],
			[u8(42), 250, 184, 196],
			[u8(2), 129, 13, 136, 6, 12, 235, 183, 38, 178, 151, 243, 27,
				88, 97, 40],
			[u8(248), 170, 168, 206], [u8(181), 220, 223, 139],
			[u8(95), 108, 201, 227], [u8(38), 221, 147, 230],
			[u8(98), 229, 5, 130, 13, 103, 248, 159, 240, 246, 56, 119, 160, 130, 82, 222],
			'hello hello hello'.bytes(), 'me me me'.bytes()]
		expected_output: [[u8(162), 67, 82, 161],
			[u8(138), 249, 111, 254, 34, 94, 136, 172, 147, 173, 214, 184, 250, 152, 22, 77],
			[u8(179), 226, 192, 110], [u8(117), 28, 66, 178],
			[u8(71), 179, 143, 86], [u8(234), 244, 13, 254],
			[u8(70), 147, 151, 204, 172, 47, 185,
				46, 60, 122, 249, 255, 76, 140, 10, 92],
			[u8(255), 163, 155, 167], [u8(114), 39, 46, 102],
			[u8(35), 253, 18, 138], [u8(90), 176, 119, 92],
			[u8(69), 177, 221, 87, 160, 165, 250,
				243, 112, 167, 125, 252, 75, 182, 253, 234],
			[u8(73), 87, 169, 226, 132, 78, 156, 251, 140, 144, 194, 27, 162, 99, 14, 213, 138],
			[u8(218), 93, 82, 52, 120, 105, 166, 160]]
	},
]

// This test `xor_key_stream` for cipher with 64-bit counter
// This samples data, was generated with golang script shared at https://go.dev/play/p/MWKBO5dNcTq
fn test_chacha20_xor_key_stream_with_64bit_counter() ! {
	for item in ch20_64bitctr_xor_key_stream_testdata {
		assert item.msgs.len == item.expected_output.len
		// creates original 64-bit counter ciphers
		mut c := new_cipher(item.key, item.nonce)!
		c.set_counter(item.counter)
		for i := 0; i < item.msgs.len; i++ {
			msg := item.msgs[i]
			exp := item.expected_output[i]
			mut dst := []u8{len: msg.len}
			c.xor_key_stream(mut dst, msg)
			assert dst == exp
		}
	}
}

// Test for ciphers `.encrypt()` methods
fn test_chacha20_encrypt_with_64bit_counter() ! {
	for item in ch20_64bitctr_testdata {
		key := hex.decode(item.key)!
		nonce := hex.decode(item.nonce)!
		plaintext := hex.decode(item.plaintext)!
		ciphertext := hex.decode(item.ciphertext)!

		mut c := new_cipher(key, nonce)!
		mut dst := []u8{len: plaintext.len}
		c.encrypt(mut dst, plaintext)
		assert dst == ciphertext

		// decrypts the ciphertext back
		// we need rekey the ciphers, because internal states has changed from previous invocations.
		c.rekey(key, nonce)!
		c.encrypt(mut dst, ciphertext)
		assert dst == plaintext
	}
}

struct Test64BitCounter {
	count      int
	key        string
	nonce      string
	plaintext  string
	ciphertext string
}

// This samples of data was generated with modified python script from
// https://cryptography.io/en/stable/_downloads/ec675a611e2a7e02dcaaa050e0fa3f10/generate_chacha20_overflow.py
// Its modified to use pycryptodome module.
// The script availables at [gist-python](https://gist.github.com/blackshirt/427e2c7b027701d2cb9e468aabc1c284)

const ch20_64bitctr_testdata = [
	Test64BitCounter{
		count:      0
		key:        '92e36bcab757adc948a074821e3a239bbb719b0bcfc73a9dfd2bd94133dbe9cd'
		nonce:      '1163c3877757e01b'
		plaintext:  '1207d93399a5b542a71be45cd53c2fc887038c5d24a12e53bc32b698f9b7232678fde2d771fa4d41333f2cf13bab7d4522ade3d7473259ac16ad24c40d55aa7d839176e7dfb8e5e2b29531eff004e867e1191bb393cfa477e4e729b915c6427c2fb4324688221ed6ce9fa8a48a38a02fbc96a6414ef843b25d0ea4fdc33129b3'
		ciphertext: '5889bf20b527f003fa56d3543b47dd5a7ba39ad331e101864170d050f3d4a0842d4eab9aebed703eceed972db4e8fec5318eb9dfc2305492879673f83b0181b216732c83924a12215e1950ea5ca8131cc500b16b056c8093846ed303ebeb1b76f8e1fe87cfb3594b1a77fd5d80d79d35d65999878654efade784a6564690e360'
	},
	Test64BitCounter{
		count:      1
		key:        'ebb674e223626ea7055543826dbc9fa282af37e654b3bec36d2604e18e9d3012'
		nonce:      '4335e49e14abcff0'
		plaintext:  'da00aae59b3e31730ee46bcc6f20924c37172d0bccfda0d781b27997b99b4f72ed86e7679337bca168aac730161adc41530208f7b274cabb077ca3a25e86d443f5339ca69a6e3381ecc23691017e36dd36f22edb866d5e45de0ae82f83b0732c9f04f1959c721d2071fcc0cce4c85acce0f87cdf70f07c08bad89a986f41aabc'
		ciphertext: 'aa6c3c697c1f1995a3dc7407af51883ef7e925d0bb366b6510c64d21fd8a00c66448c2bf9b25027ea7c3448aefc7c3d52b23a9ab79e2f952d85417d960b52dd9fb36f04260d25fa83e956898eb6101a39a2808cbd1a1a111c30dcfe0bf4ad173435dbf7c637d74f46a55db896fbc2529609e66cfe0808d2d2b9ca1bfac92cac3'
	},
	Test64BitCounter{
		count:      2
		key:        'b1a18b49a466ad38ea323ed948d5688a93bec1394da3c9068e6a9f63f4ee74d9'
		nonce:      'ed85f2233cbd2e4e'
		plaintext:  '42bf80b70b3e44923522eee2fca2ce2adac588fa206f7a110da7fcbffad7bdd59a40db918e0e7b4d018f4bec409fbeaa4940a1701ceb4cd885dc19ee703c8e6e0d41e518c3c5658ee353614be0149c4d5a6004f858826b3b445f7202ef5f63ab7837f0fca064379995893ce5275598a4cd3750a508f2be9ece6bad07ab50c52b'
		ciphertext: 'cda6a8bd300ea61816d9db6532f0067d5c54496b0eb619eda458484bdf47ffb58f647d5ab86013746eab4ad1a060035032f0b8960854cb42983a413915c12289c0d873f9300b411b12889a22bb2b8402bae57d75245a19244869fac8d7f0bd5bda8b9b869318ba6e55dcccc533651cebab5a95b30b455d59b76a98cd6fadc259'
	},
	Test64BitCounter{
		count:      3
		key:        'ff5700c34aee2e21c70ae73f709859a54fd6fb11990f1513864ffac4b5f44515'
		nonce:      'cf568e0c1a0f249d'
		plaintext:  'aa191ddfd9d9c820540a2d74950c4ad8fddcb18be41d6332094018248fd3b0fd2601a66a6d646da57a9240ed2215051d5a6e2ccfaede651f01d1587870d4a2d9fc3b639672956992139951f603c3c701dcac02a469d59e6b2d9c4c64719001d31f4643d4db4c39c2aae38edaeb88d135bccb499185450c05fcca8560af47e0c6'
		ciphertext: 'a5ecdad961e1d714bce12a374c3195f6b4bf397c190280964b4fa25edd8e70e72f0fc0f97f8d29c5e9cea19a55e7efc5a60d4f0e12617ac23a9c54484edbd590727b58dbac68fdfc868fb5f183a5ba347822c39160c8611ae44391dcd9f140bb9c3b69bee97d16361c12c11885521a689a61026188f12bb7926dd4a1cd9d75c1'
	},
	Test64BitCounter{
		count:      4
		key:        'c74a3549304e9d668105b763e13c965d08eb1c6839f2afa2e98a65f49ecd9e14'
		nonce:      '1d811a653f644793'
		plaintext:  '355729520efe3d5d9dcbde2eab169b395cf7fff557501feac176880e3f6febafbf5644798f1d63ff292b43439775e1400388acceba454abc4dc376ed5adfbaf3de31f53ae480709307b82c0e703ecc4975ff3211752f017adb12ed55675dd5e021618b9834b75cd322b307004629d1a693dd511bc5921fed8e83ea0b90bca268'
		ciphertext: 'cd17068ec40b16d8a447486664e103c2b668bc3c531231291073d4ac1bedcb6af086f24ac8291de92b2279495149efa4284a7ed083cc428807f6e081a306685560fa311808174fc60715b328b31e0cf6ad6455eff17bd87b8de08d051cbb3096c4d429c247e24b24f0cc0c8e6e2c03bf58f6c463d1717d0f2ef841d2e0a2890b'
	},
	Test64BitCounter{
		count:      5
		key:        '3e8043da72bafb208f065681217a2683a850e5369bf4042855bdefcde500ed88'
		nonce:      '2e8189d97b837d6a'
		plaintext:  '38b5a6adbb6975a8e6a617d05032e0d6cb4f50e72b7fe469bf17a75c332b2b09339c834cd16ec3117075f6572b9d719b2a07ffd7106f6b001bf00750304e0d8a8210c5154c1d923cbaacd2a0d044a0208bdc75c3f3eefba8ce77eefaf860cbd53ec3e99c40da3b9f695e3680fc942e006650246fedd0fdee6c1841755bc0827aa876f768aa5badd6fb5556660f7828e1abcab0633616d79385cb1d09c79563a1dab22995f08b98fa7c4785d2b72ec9ebb4f439bc24cf528602ef374d0f259a05'
		ciphertext: 'ebb41d20115ae7f1079f088432c16db35050556d2793f9441af234fd9b9a278e5601ca8cbe187b42c54f5969b7158a9f4faac7639f359888814c7fbab98cec895a12ba86e301be12aee8029afb0addb2aaabaead715e0653e470a584c64cd75893d8b58c35ecbdc422075ba0583b15110a6589fd971f0ae1ed8452fd333a7d8f1377e4cfdaafd31156c29d46766b542f68eb9d0240f3f2bbb41147769edb97c9629983b67f3ccbdb6981fb3fc096d48c4c9579a2d5b2752715014e8d0dfcaadb'
	},
	Test64BitCounter{
		count:      6
		key:        'f76c4a2f7ca9fab6f9c49315905fa6109fa2c7d6c3aec8d4dbee20ba009a0184'
		nonce:      'c0f9dd12c796eedb'
		plaintext:  '209b4d34dc5d48a19b0acd887b717c74869cc332ea37509d60aa4a7e0f4edb31b7d8cc64abba6d6eb95df1082e42089e9788e848b3f3fa7df8dff32fe76bb8d7d9e4f8a3f17aae1a8596b1e7b96aeba7ce53eb47642a8f2b9dd5931d03f8d7b31e22d6ce401a08a6243d32dbccdb1fe2f347c5566d1d2918e0fdce90cc9dae812d85697d2020827051b704cfff9cb19177d33c34c8cf5bc7931299cab5b09838b6da9b28802994f3d2eb54803eaa54b4c3b153c25809e0d365207a248b58b932'
		ciphertext: '20eae6a475fc418374fa302cad02b83246daad4a9aea7a57553a3d09267e479d859e9d9e5bf1407cb49c1c022d5dece0afbc16850aee020e3fb9d2befce5c1d56b7ebde1e01c6b2e6600b0a9be62187772a9248d52e63f18c30a073a696f2ac3a07fb741f6dc2c8d109c1e1911f6288c2769814a7decefc27fd4c5a622a719bbb606e2eb4ea819bb5ecdc397c676b0e2550dc19722ac2c29cf633fdd70699c877c554711d4fbd07eabdfc22ecb28b0825062f79cb901a10935548683e15c77a5'
	},
	Test64BitCounter{
		count:      7
		key:        'd2d9e6e9d50d09c4abec37d18e15dfb2349f4eea76b524011d3adc3d788ee516'
		nonce:      '35f1e345f02d8914'
		plaintext:  'e5149fb530f1e1da9d900c77a467593903dd584d7d06f908c63ef141494087acad4c22d1bf29b5c9879806a28f99eddce80e5d89d74a4138680d38fa75694a9e1e6d4364ee94d4107e808342e2ddb46eec214ceff69fcecd5aefd5c573c126c92b2518578a40019d80fd3172d8a8799dc9b626f9d0443f27ed99cc824c10adc7b249cd0366c8c0d0000e6e79b8a612c095395ec2252b8e1dd7cb71aec22e89e4776246ff3b76af025fae1d3a52b40cf9dbe2c91bf13702de0313c4a7c20ba7c9'
		ciphertext: '1e45998c9214bbc2df5df5b760005900db70970a47ccf211152fb726616089dd469bf29d83804c4d4fcb79559bfeae32ba7aa47d51ce194891ca72e8f2b93a625254ddac14899310b146f8c309c8443ceeff26121e075436798aefa5bdd9ca8249a184c7829f037708ad4d9b3b8578880d0154375be43a2e8c939b3b12884a3f5c430a84d7079fcdef486fc814466b0a60cc7222fbf3b678d30157afe627247ead86a9e4cc02ebdc6919035897a79a821e077133a55063805d9bb7a3caaa71e4'
	},
	Test64BitCounter{
		count:      8
		key:        '949062aaa9ebc3eee21a04402c69f55a4e194e1a768203dfb31e0af84d10071d'
		nonce:      '898fce6b384cf9ce'
		plaintext:  'ebf91819f515272168edbcf0c336932ce56afb3242c25bca889ea2f0530c5eee2ae6e4c317e911e0e38c5119065ce76c95b2e481ddba12ea800f7cc960e6bacd1cbe7711e8143a3f67af277c9eb91f3600e9c9870d7bdd32d9b6ee24a99c03a6029842e37f85e2608a760a3fae0c24c0bc13df3707629840e45a86f409c358d40e5a0630d70a974c08f487dd0cb25249afc0cfc80c33058a6f3781746b578f38e49f733210256ab4f9ad098e154b6916dd62f55a197017c6ffcd268c3b6317bb'
		ciphertext: 'cb7041f9faf663e87b6726710dcd257273ca04e514874efe7b337afa1c0bbe091e02b6e4e0445abb615e9275fb1875981e44ccc0e062965c0c5fb3fa8b038ba35fed9c9f7b80b7c073d7cf4233535d89dbabaa088af416250fab751a4c828cb1cafd055dc4925e3464bf3efaf7ba901aec866da8675409f7806952744977a211c82703216e245b7818465813e39b610e120e9701d4ad897db51d799ae6b7718c577dbdbaa02fad1f7628a2ac2129eef76e88188fa48dfdce1c470da98585f898'
	},
	Test64BitCounter{
		count:      9
		key:        '90ee07e4596413092e65eb3e72e99a9b445ec6859d4288feff6edbc2a1cd6234'
		nonce:      'c1674cbd44e9bd3c'
		plaintext:  'c82c7a50b259af406d0a62215f6f2994d44b2d1d448f74064e1b031088deab082283df604807b2e683f26e726e9e4676b7c3eeb8c845986967fef54584bf2227054c1387ff38fbbb0130607a0cec4ab8edcac17a24d24f454d900b8a33145423ea82ec15d05e2db97374719e0d1ddfa66c69aedbeff42d0802bf5a1c9e4a94d89659a64f47bf033b44d61fb8fc74c5008fc3835c6a6c188e24c7669d63dee8c26c31a942a69f9e5fce205e3a371a0cd02c6e5f721b5912f80a351f4509d94961'
		ciphertext: '57aa4633f75967767c6ae7666c5907323f14db83116ca3541ac817a6bdb07c5cd1ebdcf58afea7e258a08f59f57cff4bb289329abf96204cb34f38903281075f3c8072374828f103a7e397f47a68cfb4991a80a1df8d66a659f59b25a9543efaeb6fa2bd9c4e81b8263e3fb17b64cc02d45391242e11f7c17ce7a9407b3ba0f04aa110fb2d564e9237f7ed7d9979282ba7704d4b1a122d3a5131b68e60321ca7eb8a3f639766c3f6f0a6e0a9f4f027af4424b682d7cb5fbacd43d6edcc1cd3e1'
	},
	Test64BitCounter{
		count:      10
		key:        '1b2d09391e3cec618c8a6efb68bcc9bc47c20b94430446f7df2552b43fdebdb1'
		nonce:      'dcc1a35dae6652a0'
		plaintext:  '312ea8f98d2793e898e6a89afd089a1af04923b326ce8f6f17651a4aeab1d82ac722e0ddf6205eadb671ad45caccef46ef96113231898d051b4ef4241f67101d0649e5e199cf404611c8bdd0b7a41534022463ee2d5629cca8f316064fd77b7335215ecc8736cd91acb95abda7ceacbca167f4bb988eea96575520b0a4b6afacd7c61bc2807661ee9b09f433abfc8628221ac184d68c5b5f8544a9de9c61c847effc1cedf453efcbc696a1a0fce357cd91bf47132a23c80cedf8d4ba03135a37322a94ae149dba0aa794d2a5352829f89256319e68c84b910c6d021ef4b7fdd97b92bd10d21161a9bb8dc0cc9e142a3bbbdac7c1a7f8fc166b84ca0418bfcdef'
		ciphertext: 'e330a047efb404f733d1009f0e7f47a7f8f2be21a66f7b5343537dcd0b94be6d2355c89094e26d000485f943a44d0e2a59a3b2a667a701fd29bc0eae87f9b53d282f4908ba947077094905ba11bd50a7e072dc665de95bab00aa0bb6cc698c8efdc49e82b4ee4561e5ce6bca96c16bc7fe8e93b700501849f46caeb647ab65782b2e54429b9284f6d07842f9434129b0a2b3c80798b530289d91cd987db06b63541413c629bfa20658a349b0830dbdfd27c6480e50fbd0bb64e7073d20c75eedd6acdf6119b065ca9403a03f1c0cfffd832b7e4eec293367b4449f79e67940c80d704a9ffbc9942d5c3a7ae51d8c8ad0417811c36fd15f9760ad6ee9e42cdc52'
	},
	Test64BitCounter{
		count:      11
		key:        '201cc4b11ae97f7dc11f63277aaab7e55da488b15ef40f3a2b0d9fddcad63b7a'
		nonce:      '3bab2371147f4361'
		plaintext:  '27976d7e90bdd2c9f91cfc2253c9eb238e22d76ada6563e2b98bc3faa0625eb47002aae8a64aadd0e8d2d786bcc42d76721d3c329866af16b4677b48a8224a83e46cc938ee8ffa0894d13ec9f9c58cb51f1f95ea3d7e037ebd7cedc525c30cf638bbede62a4654159084b00c97214573cfa337cec47a2452c78a1b5d034703f82f5cc6986a998a3119a689cc6a01a5cdcdc68cb8ce1ac07b0e0ed71aa5a03eaeec167fa42d737d3a3f10da85165da7be3d668201b639efbda46c3867c40d5aea40756d6fc5fd8877355adf6dd2f8a81d092785c3d65868129c9ef6e06ff02c9389ce8dbfe9bde245af4da52e3e811b7a92b796b9e46bb2328257a899e4ff2831'
		ciphertext: '0f2600e15916c812a5410ed732aea3ad3d766c9c408244063993f04f619eec8a926e1b8757cb0dffbf22decb13ae4f4efe6635e9b7ab0bbccf74486245870cb3add9c1ad4bccd3ac3789c7794ee331b43c27fbcbad9fb34c2e824ba2b791c3aa82f06e3690a117d62c2d96c3e0ce256743a8b302dfc6d6c05888caf7fe7325190992e32e66735296379334d0ae1d6c9a872ba3949ff34d70890b821beb127efd858fc5e90c79a58f00f0a3eee4509e4cdf4349dcbb98b85557e7b8cf5084d6663e9c75bb7214b8484ffc3c5289a9b851ae5c36377f2435ccb8432588a17ed05de832fec09fc7ae0f786c84db7f59e6d1522bef5751907ca86e60118e86ba9260'
	},
	Test64BitCounter{
		count:      12
		key:        'a4e32a28ec6b81f2453019b8f44ea257dbd3a73eadf54d4890fe788e8d4a2300'
		nonce:      '3ed02df8abfda62a'
		plaintext:  '0b7ae124a7ce29dc87fa1fc37d3a18c20cbb259561d540bd499826be91ea4b61a97996929642631eb4ccded2928c150434d704ad2ee5d4fccd8061d10485ab7b46f3c9f470a82779820e7916b649c04cdd6ffd0d45d7c6c496a420e2fd4f79e88b3ed04bb1fec432c4cd23b80876f10465f7e5794dfa560750365c3a879e170e6262ed6b71a89938b3ee356e378e61009bfad1450c8eab7edfde01889c6a9da954b8fde9452407f3765936f3fcd876ec0df8c991e9c7a5aa54738e620472e2512d5a793f809bd98269675e3a8526f25329054166009395d8106c5765f1116f775ec388a1a66af6280bdff415c7a8cb881d9c2aee065d25951eaeb329d9b511f3'
		ciphertext: 'c365ef37a687229960b456f972b1bddfe5743f67eaf1b677f8fed979d7b5fd15971780c7254db4978d8039572376d6c012707b6af9d096b4b690d1a223f5fabf17e50cab27bcf695d72cf170ebcca237c953df2c48062eb1bbe2281d5c4e45c180e4f639d3f3fd15ac3dfab3c568a265e64c4ea140b55b8a67d4b2a94071adf019b69bbcee633037ea8329c97f8c0c71e89189218c98355c6ef0ad95f13429dfd0224f92cc147125fbe433ea513d948aff893c86e880cbb0bb856fe1837083c5aac98aefce6bc8690ad8a3a2e7f0efddf99b7dd45b12f03e1b533c8a296ebfeb1ed5adadf94a5cbeb0884434ff2d30d68c9afd1c260ad1730d07d302ca3654e0'
	},
	Test64BitCounter{
		count:      13
		key:        '1459a18ba7961489ee858aaad2a380ff5a429429348f00415837487cef66b67f'
		nonce:      'f91b4e322dd2788f'
		plaintext:  '93f2f225a854cd890e4f11fe1b3a6d449f8b4de3897c21a174221bf621406bb6d9bd94b59e7e7217557dee60747748a5aac4eeea8a0cc1f4d8564549b019d02b1843cad56bcef8aa3d810f9dcd94662d8b1a1785bb224261b2bb07df5c0c904a6d25d571de11aaf8db74887734daa9490aa10059bb31953ba256a735f4a5ccd17473bcc628506e42661b20eaccfd7bf941fcbf484f0e7649060ed70b889bd3f81fb033660ccb2b3a030199e58474841ee9ef25e5845e32bdb75691775ce9b2d1fa54bddbd24c62464189986eb4caab0567330a2c93cf2372b35f64bc2cb5dfb504ed6b7134375b5faac763a484dcd82f66e02c6c3713cc5164d2d66441505da7'
		ciphertext: '1f64dbd6d0d2f1af44bcff60abbfe758abacd747fe8b3d0b837e7eb27bae4c4484aebddcedf9966491f521956e7de08d644f3bf68a1893716b10e980772c68430062a96313daa112dd7c7c1661f24cd212e508703ff99ca642c331e9cdb5d05dd830515ea3b1c602c854529cb3900d2d6d58303a67a36e2a64fb2c43b047a9dfe2226de03f25da396da1573dd4105cc1b31c74a85dc588987db6ca867c44fc3d5fcb8d8887267691f1df062ab92c1839f0c98f4af38361ea9a14e92cc76693baafd451903c6949535bc5b436424ef1cde94e36b1d6555e4e22245ee0b1c26bda10f5813b7ecb50042604502c7b631da51c9078c4611a3cb6de0c12eecd8eb629'
	},
	Test64BitCounter{
		count:      14
		key:        'e8769dcbd6dc205448647ce6982c0e1511d477b473ee9dd7e886d19c882bb746'
		nonce:      '38eb9475a5cf8a8a'
		plaintext:  '4b4abbf0e487c0845e6ad06c7360db1562094f86207bf1aa1d7fc33909b9e2de9b9d913b7acfe11dfffe26249912508871b65c1dd86c366c106187cc0157399fc5a3368f1c85b694d071ecd3a88146ef5106924d8ce22bd12df326162d77ccadb26686a70592ed19619bd6aaa8c2254a2b906954625208724e69d580765ec1ef22a46104aa52819c066b00533054d8ae4abd6e2ac0a2dddd138cba1773f29a7b7f8eba11811818ecc93845a943e2bce1cacdbd92b0663ae2178f43e20a808254b8d2ff56dd0152414a073c0cbe3b9d3b2c96dd3379b04eeee20eb518ef56a3ddcab8431d6b46e2ff89e5fdec1d5ba6b73bd0e3fa0a20a3421db706d398c65466'
		ciphertext: '0c7478fee0badabe8bc6e646c510dddb79eedcb8b80a3fd71a36aa23171472574dde019c278b3067891a19a746b946721edb71b2ced9b0ec6eda026442a7fdee4f891ff9a2deb8edd7e36fdf9a762da8091015a558f89c1cdca24d440c3d4a66fe397e6f4298f3ffd419a206a72c1e124942e38b13e1c7fbdb382cfa95bd466a050249d3b9a424469d13e474b2ba64dc3b4675dc4054c15970098824e172b718d2873b1b1ed635ae2a089eecba761b3c451555a59ceb97e655f5e6f704e5b15b9446cb176ce6f733699c29c22069c3036e8e27e0b95540fbf6b8beab4b31922877b0911dbca5639fe48a25dabda53b1a607a2cdc78360674623828e892c96497'
	},
	Test64BitCounter{
		count:      15
		key:        '6ba24bd567d5225bcf80e66e1e09ae4fe6141b3537b06cc3228c73265895ba76'
		nonce:      '84e4217bc8c017ae'
		plaintext:  'dd983cb7f1fbce7dee4cb30a95419205f0848a2f2d6306e0bb156c646430f8b65fb2c5211a1a9e468c5523f507ba2564456723e3fbeb47700afd5b3f7290f8d43e9f41e8b311e440e4e66b292c59e5b23e6aab27423ef8465c5b8ee8cf46d8a0be971d8b44689ec42a648b6cab1c0800d0d541a01fb5fe783cbec8837021d48a3e1e69e3a6c87d600a570fcd4cd1d91e6ecfd45506d6c626b3b9e0509f221f65209dd6d6e9fd9b84820139516ab24607cb6d865046c3c222246d42cd855799ce1f8efa17bb2f1c7e65c88f3e911fd65b76d814ed04a75e57c192c459ff15080d6731735259149a2828c1490081c398cf951950885c409aefc7ceaa95225d99afb51a0772e0625b7b1f83db82f59c294b912d5d54b6bafade92f30a48b24c7ed9f7dec0470d668996c9bbf43ebba3cf1fb129db5d7aff5e5aab85d5f2671010cb'
		ciphertext: '2f033be2d3eef9182cff7ad8fff2b17a5621c048326d1fd06b5ca2f7d4bae46cc4496ab1dd05c998003feea4eaa4c9d485946db3be0ed68f453f424442935e8029b353d054876c06d5d11a76f780ae79ee52db4260bf7a3b8995c326d057af724d5f5c90782087c31451c3a19ad94c3988e4944c1cf5c11e8a6b1bc83360ff5aea4f478f183deef1bb55548575c6a633a0d8b0a0e91c3688687e684e45e10eff6a9360ee04bebed51c785acf66cff31c269b478bfa44656371aa882ca03c46c20bca60dec029843e524359f8d65c7460e777e52a332a79cc230730624d61f9f64a78f4e3a36a86915604f2c47180dd1fbb366ac30de090a107dd172bca2973ded64fd96dc2f4cc3e8a6caed0ef979eee46656effde1c64d346537a6634c5d61bf54a2f2fe52605577821f63ac570457820b2f8090ee91f2d26debcf1aa8e6c2d'
	},
	Test64BitCounter{
		count:      16
		key:        '9cf17c37b0fa88a6f7d4a91043e4833cf2f10cbcaa420345d0f06d8e176dfd86'
		nonce:      'b6519fa7681c731c'
		plaintext:  'c0a47514640b69defdbd07fbf5a96e6a3de22259d70c067cdaa42b7f8e26a79006bc29ddf2971f0c658875519c92a84cb777e4554d62a026bea65fcef614a13926de69a01280d2614eebb1c4ce8e21ec5ae65bc083736d2609bbfe5acff306837d84ffeca31baede9a470666434a06d37f22ba0edd03d53bf24fe35fac185aedc984b4fad1526b5353e79ee6322adf5ea60de493771d476162aad1c5c465384cf6bbee233ccb32e28b21a03d52be963cb529f7691285ca99cf1c911904e5f9fdb51534c197e0434bdf5a9e29fc61b436ecc7106dc2cf88eb239dea6fba04fe6d2a11c3b8ec777aed8814941b60dd148206cdc237e1582e3a2b8f5f048770fd267ba27010c611215e0d8e13af8ee088b40f37513870ce76bf26b7907be7249682606ae1c01892eab7cbe5244368d8a97fd2f3c7b1cbfe6185b11a26cdb60ec682'
		ciphertext: '289040be9b21100a61f3573a77bda5787aea4e9770c143c6f2eb03aeba87b8f5b580c896e015c7c05c4f424910d86fcb5a4fc8f51ca8f2cd672dc897b1142bdafde5f3bdb9c159c41e375d25029aaccae1973f76c914e6ef63fbb0b60d51f62b79e8fb0278b89b8e153538f87e9796b124930ec14ba069687fe228970b5452f2d89b8b9f1d8c999204725b283dca62fabd401fdf5733e73bcb078ed19977aed2f427eb043685e239b97a99ca761d87ffb8c3d5afd59e3c96f225efbafcae409d9e27a0cb42e6e0f065e0f5376ae1822472c1cded4a02476462c6a8f04a2c0eb3c8fffcfb072e40ea4a7b6e89d3e820598a0aa1641a7d05afc603aa03bd9d01a66f1fd66ad348f51dcb735162cbbbc64fc65e360afb60259343f6ac76fd53cc119b101d662d2cf479be5c375055d0fdfc6a261b835f08c7761c0cb958b67e67ef'
	},
	Test64BitCounter{
		count:      17
		key:        'c7fed7eb488e581239e625800c913ebc1984d4d11ffd2fcddb7ef5e3f56fb62f'
		nonce:      'bc036490f63175de'
		plaintext:  '00f3c22b28d6fcd4e2d8057e11a8b69632831558f06274d9998dd97b1920e700c28ba52235812604073b205b436b665248caa3103f348c815b4b8545b230ab9545ae42f3352982ed0005e4750c09d090419709c64e59fb163bb222e92700142a45d0f14aff0791b118c1e49ccb42d22f080074344c8d323c6266b482651d19b79b9565d0f1b3e6e7ed6604cd89f606ad0b5f13d8d7f0d21fe21120bf3895c87512817aa97d689a5c6899996f870c92b4d9eaa3d51906625ddadad459245faf236513da4f2481d78831ce9e3191a11385971b889c80e93fb8c8ecbd7c0a31dc71a5fe3afa11d75b32c162bb32de6424138e2384a0bbe4be89981eb40b210dfb7e611384f5973b2afb42c70c7f4c148d4e175a039438d5df40ef90ed43d7d20c50aee5000e03d36b748c981e53e97b7d103df3160d677c55bbfe7fff6896bc39bd'
		ciphertext: '15af8542f929760d54486a48033baf7cc4c9f202c8841eca194f51d70b6f4ba96d677b2f6e36744cfff6f9a8060b710f247272054b440e466cf15b969282723eca264df498460eb4632dbb29c386bc3078a86863aa01cd6243e77b09bfabb600ee472ed18f8407128c963c8e445aeea79e014679ee34bbf7d42f9fbf0978213502316ccd6a8ad2975ef8a7568798d1991f43e4de6524b9b286954c3b4664c7f93adb152e9c919eb549b5f97683310bb4bdb2eb639c48ec1779d9c9d5e99f0cf011e3a86a8d3d96569d9450caf27ce1f3a5c4a568d56af7a7ceaffd9368b146c43f21d924030d59a1c89f88952d453592ef9906ff98cdf0528d1b8384384ac048246574aac326613812a6b90c7d3917d63166a4d9bc1fc53e907d4b6eacffb7b5b6718289b649aa3a80d74cc783064b51bef94948f12650d4380659629c6eeaec'
	},
	Test64BitCounter{
		count:      18
		key:        'a20bd2d0e828d7deaa018f500bbaeb03c4a81886413f5aea47700831575ad64e'
		nonce:      'a460cb1817b8135a'
		plaintext:  'ecb555070264c9638703cacb45c26317e098f3a663fa9879bc50c8ac0486dbc6bf635f02641ea7caf39fb0208cebb3d013de59881b0d412c578cfd0f7f13022fe94b9ccfae593d692a7cb309c0028960132b07264bb074c9083cd55ac1677fc374506f37a8dcd7945ac7ee48ffaeb73434e14e02855ce38bcd36d6e97fdd5e3b1d49705f1fee92286d178c863629a4f1e60a9e11f914ba43406468d63f6634c4ec6e5f4d96d2081fa4df577d76a6bb56c4c4fd688fce7c612c618f3d6a54dea3186232b00f0e19e77f0408419620b683724bd724defc80caa61e69bf7fd2d91b3a810c1158d01437493b7365c4a82d92a6e231d0d1ab455abae30ce7938fb282cb8dfb893ae50f0c7f17dff5179b8e83fc9caab6b12eb8e73c2597405bc7618f409cf1ff27caf832708d8c8dd7c6ac6c463b3e526ff25c94d77a71ddbdab2b03'
		ciphertext: '1902d0307c587e631b88f06b81317244cbf31423f434b63d18a946449f6c0ce123eb8cd0d8507218220197cbc5729f4598d136ac2722a5c18f3ec83f987823dde03482206c6e22be2a4a80e88f5f1b2f6ccd6b6c56c831b72d2cafe9c0503c9098e08e09f94429561fdccd1262b9205d9da324488133381e09636490f59b3ae32ff0bb57313db9a0ed8b8df1d2f2978e34cbcde8cc1944ced4b1b36db522b4e82460ebe976e8f271625e9403b80a356d8ac661e4a0ef05fc103a3b39e008391e41fa4d4a26db57dfe8d090c94cbd6bc06dd44ce86c4707d3c722a811d1c990ded50e9505309054d89b5c41991aeb61f3848820872177db410d468e5d365eb8cd58774a11759ad17efd5df875c5c59340833f8e869df16795509eaf979bb4ee02ca3e5f5ced77d4e428f75563c07a6962d29357f6435d6124121f77b5b9f6e74e'
	},
	Test64BitCounter{
		count:      19
		key:        'cd52a641ba6248a478197f156ff06b54f59e8447e72934945ac2a8ec34577658'
		nonce:      '175d0496aef23968'
		plaintext:  '31af4c534f5eabdd9935b7d82325aa17477811fde852ec1a517f9c0c187c941e7d285f014a95d674d11b7519112e1af45f14f0ea8284b6c02a8f21a7a3fe13fec10a6351f32e9c8b65f1c206de661516287dbae87ab16da9fccb2a32ae1609203545a2074931781ed832a47c19bfd51355737f1b8b08334e25ca6a6f3ad64354aa5fb341dc351c1499812455ccb6271d724a5db4cf62b04964aba246458fd2704d9f679c5ee919e1166e4758b615d5ef8b4d3f8a437ec01e3c1b21f2556b922538d380c07370990fd7daa93c4caf4413030a4003a7d8de18a50f9178e413f36ba72e294d26b7ca8885971ef3e93f6020365e5de50dcb39f89754ee5e3441204476f365378a07e68363bf5516910d5ae0cd84e5104418937a0459ddb2614e21a16267661fc5913c9d01dfe9f7e2d8e602d7bd1c12f6511a5d5b9310ec8e12d857'
		ciphertext: '900ce9b0ea6d55f56d4d25d84b2a0fd8637f9149dd0217b6db79c2dd26aa3d20d1c80f5132269efcd262fbc7ee4c5d8a426f16368c7362b8c5b45dd73977806d8ecd54b0f5d3d0cc23ae409bfe2fe1a040706cb118926c2a605da10afc95e75b7fe9ac4d1681639c17e9aeeddc815c046504fcea19173df94450484379886c5da1b4416a91f881ddc4db81ed0a03dd63e1afa699a683c45749f7c4cb56a670bb9be4731586210b5009157153ae8b019abb731b154d81f5554811f6bc000135e811c18267657ef8f39d6ae287ed6c6f0be153c018240d50e90b2607eb042bfa6373e67cdd0cd0bad7febe8cfde9d4981429f61b634f0a5451b79c8a9c18454387c57fbe261ec5d3207ac7f386f807de3a517765c18e25ec732cffe2fd2489959893b847e439f0f91501b07ec811e08273538b633da8ecba645b27ae7deec17575'
	},
	Test64BitCounter{
		count:      20
		key:        '917d50a9ea435b08e49987bee4f060bd086e4fc10e0881d88df10464dae2374e'
		nonce:      'fa8ccbe7f42dfcf1'
		plaintext:  '941998a93507ef7037eb04ff250aa2ac09ee4c7ca880b49bbb3ec34f476658c6bc29db656d40a0e9360721040bdc28617adab92574a730e8be8fb89964f8af011c8ff59ac09676643b7eef31d9fc85964b132dafce8e692ad7a921813bc1e1b3460fc1e26ee1754aa0cdfd5e4953571adac3c84b9678700590e5c976e240ffa01054e9badace91d5f39cd217d860af6ae6051089b0a32fa0e52680dbbb7afc99e20d42f89d87713f1c0fe51fc315948308d15cdeace2c46b8ffd6783b13034ca220e0381e5c77180ef844060f8eb33ade84c04602a509352af3d0222190643789acbbdd8a69a36abc68eb3175f1838333f970b94043811103ae1ef737e58577e8aa6aa41af187854e1924cc9ebcc785ba7252c57c75344a3b1dd8e6c0d3992a994516d2d5451e9059d044103c50e7f8e028b486664f986a496b197885d2de8525f879e7b7a0b5826eebd8412797a8af4345e0b63fb7957e05188750b02e796e055db133eb1bcd9e3f0e650e955e4efd496704166f6efa51737277d4c5cc0f45f'
		ciphertext: '2ae8f96aa8228a9fa1c3ab60ea1af2ed611b845ef023ff918cabc8faa0db09b7dca7e2f8329305fabf37f009b925d7d8a5cb336c31185c2929f52ad1fd84e64986cc8bdbef32ce4e04406e318a9020f3470ae2fbafd0c42cc3f2debf4fcb6398acd67415e8b2457e9668c86b179c44479d9ff157ddc20bb7c466ebcb18592eed2d68c6f074ad87c8e5098031e8fb9630545ae998b4da77908c30dc840112d93171619def1b04b62cde3e3a79f2295e84c63e5c80dbd1602be391f28ff4c7a360003280c868862f195fda2733b5f681c28d07893630205d821ec250d368f26dd9faa016e3a99d089d271ad2b4c4e246c7938d726d5a2e9f841e506aeea45824d4ce17b20dd36742e10ec972a72e512b0bbff9fe0ecb1d9bd6edc710a485ca5b01465cf8f916196af3e5577ef6f544984c29a91f8bd4312e927477efe66f36cb70a3bbd8d47a30707004fdae69f731e5e37b943b0469c3a819342cbb469bfebd171768579fcc3fddcf53a02b6f3bc6792a774048a3867b52f7691222992e48fa97'
	},
	Test64BitCounter{
		count:      18446744073709551614 // fffffffffffffffe
		key:        '35b7328ca227b329a4d9e0bc55239338034c08c5082383bc8e22d60410de959a'
		nonce:      'afa330fba5925cb0'
		plaintext:  '17211d01b2acf4dc24ca3a83bf95b44c0ec432cecfd692d6af273a72ee0320ef7c609ec234ae3dc528ebff03357eaed795b8bd6cfb36411c2e291a1daafaebf67f6ccb94e1bfe017a6f04657312502eca502fbd41111a4242a8a9ad8571f487b5f75394b385caf21bcb85ec30de4088ed6c448739536eb50c8fa1b6f664db8cd'
		ciphertext: 'd3980299fe1bb99ec70d42630c6c8d933fe2f161f1608ccc57a925818f2d6dbffc9d92a159f5883ce3d732b95521da45678529f8db08c22e7e01bebb4697039873880f8586d6e3be6048c346057959a63a3c17a5d96c158059bdf28963fe910b2ca900baf6ee879653f4f63ef0fe883afd83c540adbe21d97b736a478fc0cba4'
	},
	Test64BitCounter{
		count:      18446744073709551615 // ffffffffffffffff
		key:        'ad20701d42494e2d907838bc872e54511b0ed084fc64ec0a44d0269b331da9ab'
		nonce:      '31c9ac97f9023ed3'
		plaintext:  '63058a0f6c9e238838f3c3a68c1dbb9fa0028880f9bc9ce72531a630eb0608d351d7168470a5eda7537d6fb12f0e961967acd7d6e2d6eacc90cc3b00fd279575ef6a5c0175e7aedb0ae83ee0f7817fc8da2250dd7eac7005ce98159abf3f86eb89ed4299fd6ae6033c884190b3225676d7d5ba11f5e25a9a58ffcff4264d1c37'
		ciphertext: '6cda3c0f72707d18ba81f92427407e5498737af0189efe7821e07b8a1323437764defbe120487d39327c0a2eff390ee58d7bceb3bdcf770c9448b3226019de7e933216080012663df8933d16be54e399aafe3f86594bd6b2f87fe9b8ca8767b37fdfab7968b5f1ce25ee8acb2c5d05825eb6cde9ce5a700c5e249976a3b03eea'
	},
]
