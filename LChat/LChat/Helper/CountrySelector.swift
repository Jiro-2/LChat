import Foundation


typealias Country = (name: String?, flag: String?, callingCode: Int?)

protocol CountrySelectable {

    func getCountry(_ codeISO: String) -> Country
    func getCountryCodes() -> [String]
    func getAllCountries() -> [Country]
}


struct CountrySelector: CountrySelectable {
   
    
    //MARK: - Public
    
    
    func getCountry(_ codeISO: String) -> Country {
        
      return  countries[codeISO] ?? (name: "No name", flag: "No flags", callingCode: nil)
    }
    
    
    func getCountryCodes() -> [String] {
        
        Array(countries.keys).sorted()
    }
    
    
    func getAllCountries() -> [Country] {
        
        Array(countries.values)
    }
    
    

    //MARK: - Private
   private let countries: [String:(name: String, flag: String, callingCode: Int)] = [
        
        "AD":(name: "Andorra", flag: "🇦🇩", callingCode: 376),
        "AE":(name: "United Arab Emirates", flag: "🇸🇦", callingCode: 971),
        "AF":(name: "Afghanistan", flag: "🇦🇫", callingCode: 93),
        "AG":(name: "Antigua and Barbuda", flag: "🇦🇬", callingCode: 1),
        "AI":(name: "Anguilla", flag: "🇦🇮", callingCode: 1),
        "AL":(name: "Albania", flag: "🇦🇱", callingCode: 355),
        "AM":(name: "Armenia", flag: "🇦🇲", callingCode: 374),
        "AO":(name: "Angola", flag: "🇦🇴", callingCode: 244),
        "AR":(name: "Argentina", flag: "🇦🇷", callingCode: 54),
        "AT":(name: "Austria", flag: "🇦🇹", callingCode: 43),
        "AU":(name: "Australia", flag: "🇦🇺", callingCode: 61),
        "AW":(name: "Aruba", flag: "🇦🇼", callingCode: 297),
        "AZ":(name: "Azerbaijan", flag: "🇦🇿", callingCode: 994),
        "BA":(name: "Bosnia and Herzegovina", flag: "🇧🇦", callingCode: 387),
        "BB":(name: "Barbados", flag: "🇧🇧", callingCode: 246),
        "BD":(name: "Bangladesh", flag: "🇧🇩", callingCode: 880),
        "BE":(name: "Belgium", flag: "🇧🇪", callingCode: 32),
        "BF":(name: "Burkina Faso", flag: "🇧🇫", callingCode: 226),
        "BG":(name: "Bulgaria", flag: "🇧🇬", callingCode: 359),
        "BJ":(name: "Benin", flag: "🇧🇯", callingCode: 229),
        "BH":(name: "Bahrain", flag: "🇧🇭", callingCode: 973),
        "BI":(name: "Burundi", flag: "🇧🇮", callingCode: 257),
        "BL":(name: "Saint Barthelemy", flag: "🇧🇱", callingCode: 590),
        "BM":(name: "Bermuda", flag: "🇧🇲", callingCode: 441),
        "BN":(name: "Brunei", flag: "🇧🇳", callingCode: 673),
        "BO":(name: "Bolivia", flag: "🇧🇴", callingCode: 591),
        "BR":(name: "Brazil", flag: "🇧🇷", callingCode: 55),
        "BS":(name: "Bahamas", flag: "🇧🇸", callingCode: 1),
        "BT":(name: "Bhutan", flag: "🇧🇹", callingCode: 975),
        "BW":(name: "Botswana", flag: "🇧🇼", callingCode: 267),
        "BY":(name: "Belarus", flag: "🇧🇾", callingCode: 375),
        "BZ":(name: "Belize", flag: "🇧🇿", callingCode: 501),
        "CA":(name: "Canada", flag: "🇨🇦", callingCode: 1),
        "CC":(name: "Cocos Islands", flag: "🇨🇨", callingCode: 61),
        "CD":(name: "Democratic Republic of the Congo", flag: "🇨🇩", callingCode: 243),
        "CF":(name: "Central African Republic", flag: "🇨🇫", callingCode: 236),
        "CG":(name: "Republic of the Congo", flag: "🇨🇬", callingCode: 242),
        "CH":(name: "Switzerland", flag: "🇨🇭", callingCode: 41),
        "CI":(name: "Ivory Coast", flag: "🇨🇮", callingCode: 225),
        "CK":(name: "Cook Islands", flag: "🇨🇰", callingCode: 682),
        "CL":(name: "Chile", flag: "🇨🇱", callingCode: 56),
        "CM":(name: "Cameroon", flag: "🇨🇲", callingCode: 237),
        "CN":(name: "China", flag: "🇨🇳", callingCode: 86),
        "CO":(name: "Colombia", flag: "🇨🇴", callingCode: 57),
        "CR":(name: "Costa Rica", flag: "🇨🇷", callingCode: 506),
        "CU":(name: "Cuba", flag: "🇨🇺", callingCode: 53),
        "CV":(name: "Cape Verde", flag: "🇨🇻", callingCode: 238),
        "CX":(name: "Christmas Island", flag: "🇨🇽", callingCode: 61),
        "CY":(name: "Cyprus", flag: "🇨🇾", callingCode: 357),
        "CZ":(name: "Czech Republic", flag: "🇨🇿", callingCode: 420),
        "DE":(name: "Germany", flag: "🇩🇪", callingCode: 49),
        "DJ":(name: "Djibouti", flag: "🇩🇯", callingCode: 253),
        "DK":(name: "Denmark", flag: "🇩🇰", callingCode: 45),
        "DM":(name: "Dominica", flag: "🇩🇲", callingCode: 1),
        "DZ":(name: "Algeria", flag: "🇩🇿", callingCode: 213),
        "EC":(name: "Ecuador", flag: "🇪🇨", callingCode: 593),
        "EE":(name: "Estonia", flag: "🇪🇪", callingCode: 372),
        "EG":(name: "Egypt", flag: "🇪🇬", callingCode: 20),
        "ER":(name: "Eritrea", flag: "🇪🇷", callingCode: 291),
        "ES":(name: "Spain", flag: "🇪🇸", callingCode: 34),
        "ET":(name: "Ethiopia", flag: "🇪🇹", callingCode: 251),
        "FI":(name: "Finland", flag: "🇫🇮", callingCode: 358),
        "FJ":(name: "Fiji", flag: "🇫🇯", callingCode: 679),
        "FK":(name: "Falkland Islands", flag: "🇫🇰", callingCode: 500),
        "FM":(name: "Micronesia", flag: "🇫🇲", callingCode: 691),
        "FO":(name: "Faroe Islands", flag: "🇫🇴", callingCode: 298),
        "FR":(name: "France", flag: "🇫🇷", callingCode: 33),
        "GA":(name: "Gabon", flag: "🇬🇦", callingCode: 241),
        "GB":(name: "United Kingdom", flag: "🇬🇧", callingCode: 44),
        "GD":(name: "Grenada", flag: "🇬🇩", callingCode: 1),
        "GE":(name: "Georgia", flag: "🇬🇪", callingCode: 995),
        "GG":(name: "Guernsey", flag: "🇬🇬", callingCode: 44),
        "GH":(name: "Ghana", flag: "🇬🇭", callingCode: 233),
        "GI":(name: "Gibraltar", flag: "🇬🇮", callingCode: 350),
        "GL":(name: "Greenland", flag: "🇬🇱", callingCode: 299),
        "GM":(name: "Gambia", flag: "🇬🇲", callingCode: 220),
        "GN":(name: "Guinea", flag: "🇬🇳", callingCode: 224),
        "GQ":(name: "Equatorial Guinea", flag: "🇬🇶", callingCode: 240),
        "GR":(name: "Greece", flag: "🇬🇷", callingCode: 30),
        "GT":(name: "Guatemala", flag: "🇬🇹", callingCode: 502),
        "GU":(name: "Guam", flag: "🇬🇺", callingCode: 1),
        "GW":(name: "Guinea-Bissau", flag: "🇬🇼", callingCode: 245),
        "GY":(name: "Guyana", flag: "🇬🇾", callingCode: 592),
        "HK":(name: "Hong Kong", flag: "🇭🇰", callingCode: 852),
        "HN":(name: "Honduras", flag: "🇭🇳", callingCode: 504),
        "HR":(name: "Croatia", flag: "🇭🇷", callingCode: 385),
        "HT":(name: "Haiti", flag: "🇭🇹", callingCode: 509),
        "HU":(name: "Hungary", flag: "🇭🇺", callingCode: 36),
        "ID":(name: "Indonesia", flag: "🇮🇩", callingCode: 62),
        "IE":(name: "Ireland", flag: "🇮🇪", callingCode: 353),
        "IL":(name: "Israel", flag: "🇮🇱", callingCode: 972),
        "IM":(name: "Isle of Man", flag: "🇮🇲", callingCode: 44),
        "IN":(name: "India", flag: "🇮🇳", callingCode: 91),
        "IO":(name: "British Indian Ocean Territory", flag: "🇮🇴", callingCode: 246),
        "IQ":(name: "Iraq", flag: "🇮🇶", callingCode: 964),
        "IR":(name: "Iran", flag: "🇮🇷", callingCode: 98),
        "IS":(name: "Iceland", flag: "🇮🇸", callingCode: 354),
        "IT":(name: "Italy", flag: "🇮🇹", callingCode: 39),
        "JE":(name: "Jersey", flag: "🇯🇪", callingCode: 44),
        "JM":(name: "Jamaica", flag: "🇯🇲", callingCode: 1),
        "JO":(name: "Jordan", flag: "🇯🇴", callingCode: 962),
        "JP":(name: "Japan", flag: "🇯🇵", callingCode: 81),
        "KE":(name: "Kenya", flag: "🇰🇪", callingCode: 254),
        "KG":(name: "Kyrgyzstan", flag: "🇰🇬", callingCode: 996),
        "KH":(name: "Cambodia", flag: "🇰🇭", callingCode: 855),
        "KI":(name: "Kiribati", flag: "🇰🇮", callingCode: 686),
        "KM":(name: "Comoros", flag: "🇰🇲", callingCode: 269),
        "KN":(name: "Saint Kitts and Nevis", flag: "🇰🇳", callingCode: 869),
        "KP":(name: "North Korea", flag: "🇰🇵", callingCode: 850),
        "KR":(name: "South Korea", flag: "🇰🇷", callingCode: 82),
        "KW":(name: "Kuwait", flag: "🇰🇼", callingCode: 965),
        "KY":(name: "Cayman Islands", flag: "🇰🇾", callingCode: 345),
        "KZ":(name: "Kazakhstan", flag: "🇰🇿", callingCode: 7),
        "LA":(name: "Laos", flag: "🇱🇦", callingCode: 856),
        "LB":(name: "Lebanon", flag: "🇱🇧", callingCode: 961),
        "LC":(name: "Saint Lucia", flag: "🇱🇨", callingCode: 758),
        "LI":(name: "Liechtenstein", flag: "🇱🇮", callingCode: 423),
        "LK":(name: "Sri Lanka", flag: "🇱🇰", callingCode: 94),
        "LR":(name: "Liberia", flag: "🇱🇷", callingCode: 231),
        "LS":(name: "Lesotho", flag: "🇱🇸", callingCode: 266),
        "LT":(name: "Lithuania", flag: "🇱🇹", callingCode: 370),
        "LU":(name: "Luxembourg", flag: "🇱🇺", callingCode: 352),
        "LV":(name: "Latvia", flag: "🇱🇻", callingCode: 371),
        "LY":(name: "Libya", flag: "🇱🇾", callingCode: 218),
        "MA":(name: "Morocco", flag: "🇲🇦", callingCode: 212),
        "MC":(name: "Monaco", flag: "🇲🇨", callingCode: 377),
        "MD":(name: "Moldova", flag: "🇲🇩", callingCode: 373),
        "ME":(name: "Montenegro", flag: "🇲🇪", callingCode: 382),
        "MF":(name: "Saint Martin", flag: "🇫🇷", callingCode: 590),
        "MG":(name: "Madagascar", flag: "🇲🇬", callingCode: 261),
        "MH":(name: "Marshall Islands", flag: "🇲🇭", callingCode: 692),
        "MK":(name: "Macedonia", flag: "🇲🇰", callingCode: 389),
        "ML":(name: "Mali", flag: "🇲🇱", callingCode: 223),
        "MM":(name: "Myanmar", flag: "🇲🇲", callingCode: 95),
        "MN":(name: "Mongolia", flag: "🇲🇳", callingCode: 976),
        "MO":(name: "Macau", flag: "🇲🇴", callingCode: 853),
        "MP":(name: "Northern Mariana Islands", flag: "🇲🇵", callingCode: 670),
        "MS":(name: "Montserrat", flag: "🇲🇸", callingCode: 664),
        "MT":(name: "Malta", flag: "🇲🇹", callingCode: 356),
        "MU":(name: "Mauritius", flag: "🇲🇺", callingCode: 230),
        "MV":(name: "Maldives", flag: "🇲🇻", callingCode: 960),
        "MW":(name: "Malawi", flag: "🇲🇼", callingCode: 265),
        "MX":(name: "Mexico", flag: "🇲🇽", callingCode: 52),
        "MY":(name: "Malaysia", flag: "🇲🇾", callingCode: 60),
        "MZ":(name: "Mozambique", flag: "🇲🇿", callingCode: 258),
        "NA":(name: "Namibia", flag: "🇳🇦", callingCode: 264),
        "NC":(name: "New Caledonia", flag: "🇳🇨", callingCode: 687),
        "NE":(name: "Niger", flag: "🇳🇪", callingCode: 227),
        "NG":(name: "Nigeria", flag: "🇳🇬", callingCode: 234),
        "NI":(name: "Nicaragua", flag: "🇳🇮", callingCode: 505),
        "NL":(name: "Netherlands", flag: "🇳🇱", callingCode: 31),
        "NO":(name: "Norway", flag: "🇳🇴", callingCode: 47),
        "NP":(name: "Nepal", flag: "🇳🇵", callingCode: 977),
        "NR":(name: "Nauru", flag: "🇳🇷", callingCode: 674),
        "NU":(name: "Niue", flag: "🇳🇿", callingCode: 683),
        "NZ":(name: "New Zealand", flag: "🇳🇿", callingCode: 64),
        "OM":(name: "Oman", flag: "🇴🇲", callingCode: 968),
        "PA":(name: "Panama", flag: "🇵🇦", callingCode: 507),
        "PE":(name: "Peru", flag: "🇵🇪", callingCode: 51),
        "PF":(name: "French Polynesia", flag: "🇵🇫", callingCode: 689),
        "PG":(name: "Papua New Guinea", flag: "🇵🇬", callingCode: 675),
        "PH":(name: "Philippines", flag: "🇵🇭", callingCode: 63),
        "PK":(name: "Pakistan", flag: "🇵🇰", callingCode: 92),
        "PL":(name: "Poland", flag: "🇵🇱", callingCode: 48),
        "PM":(name: "Saint Pierre and Miquelon", flag: "🇵🇲", callingCode: 508),
        "PN":(name: "Pitcairn", flag: "🇵🇳", callingCode: 64),
        "PR":(name: "Puerto Rico", flag: "🇵🇷", callingCode: 1),
        "PS":(name: "Palestine", flag: "🇵🇸", callingCode: 970),
        "PT":(name: "Portugal", flag: "🇵🇹", callingCode: 351),
        "PW":(name: "Palau", flag: "🇵🇼", callingCode: 680),
        "PY":(name: "Paraguay", flag: "🇵🇾", callingCode: 595),
        "QA":(name: "Qatar", flag: "🇶🇦", callingCode: 974),
        "RE":(name: "Reunion", flag: "🇫🇷", callingCode: 262),
        "RO":(name: "Romania", flag: "🇷🇴", callingCode: 40),
        "RS":(name: "Serbia", flag: "🇷🇸", callingCode: 381),
        "RU":(name: "Russia", flag: "🇷🇺", callingCode: 7),
        "RW":(name: "Rwanda", flag: "🇷🇼", callingCode: 250),
        "SA":(name: "Saudi Arabia", flag: "🇸🇦", callingCode: 966),
        "SB":(name: "Solomon Islands", flag: "🇸🇧", callingCode: 677),
        "SC":(name: "Seychelles", flag: "🇸🇨", callingCode: 248),
        "SD":(name: "Sudan", flag: "🇸🇩", callingCode: 249),
        "SE":(name: "Sweden", flag: "🇸🇪", callingCode: 46),
        "SG":(name: "Singapore", flag: "🇸🇬", callingCode: 65),
        "SH":(name: "Saint Helena", flag: "🇸🇭", callingCode: 290),
        "SI":(name: "Slovenia", flag: "🇸🇮", callingCode: 386),
        "SJ":(name: "Svalbard and Jan Mayen", flag: "🇳🇴", callingCode: 47),
        "SK":(name: "Slovakia", flag: "🇸🇰", callingCode: 421),
        "SL":(name: "Sierra Leone", flag: "🇸🇱", callingCode: 232),
        "SM":(name: "San Marino", flag: "🇸🇲", callingCode: 378),
        "SN":(name: "Senegal", flag: "🇸🇳", callingCode: 221),
        "SO":(name: "Somalia", flag: "🇸🇴", callingCode: 252),
        "SR":(name: "Suriname", flag: "🇸🇷", callingCode: 597),
        "ST":(name: "Sao Tome and Principe", flag: "🇸🇹", callingCode: 239),
        "SV":(name: "El Salvador", flag: "🇸🇻", callingCode: 503),
        "SY":(name: "Syria", flag: "🇸🇾", callingCode: 963),
        "SZ":(name: "Swaziland", flag: "🇸🇿", callingCode: 268),
        "TC":(name: "Turks and Caicos Islands", flag: "🇹🇨", callingCode: 1),
        "TD":(name: "Chad", flag: "🇹🇩", callingCode: 235),
        "TG":(name: "Togo", flag: "🇹🇬", callingCode: 228),
        "TH":(name: "Thailand", flag: "🇹🇭", callingCode: 66),
        "TJ":(name: "Tajikistan", flag: "🇹🇯", callingCode: 992),
        "TK":(name: "Tokelau", flag: "🇹🇰", callingCode: 690),
        "TL":(name: "East Timor", flag: "🇹🇱", callingCode: 670),
        "TM":(name: "Turkmenistan", flag: "🇹🇲", callingCode: 993),
        "TN":(name: "Tunisia", flag: "🇹🇳", callingCode: 216),
        "TO":(name: "Tonga", flag: "🇹🇴", callingCode: 676),
        "TR":(name: "Turkey", flag: "🇹🇷", callingCode: 90),
        "TT":(name: "Trinidad and Tobago", flag: "🇹🇹", callingCode: 868),
        "TV":(name: "Tuvalu", flag: "🇹🇻", callingCode: 688),
        "TW":(name: "Taiwan", flag: "🇹🇼", callingCode: 886),
        "TZ":(name: "Tanzania", flag: "🇹🇿", callingCode: 255),
        "UA":(name: "Ukraine", flag: "🇺🇦", callingCode: 380),
        "UG":(name: "Uganda", flag: "🇺🇬", callingCode: 256),
        "US":(name: "United States", flag: "🇺🇸", callingCode: 1),
        "UY":(name: "Uruguay", flag: "🇺🇾", callingCode: 598),
        "UZ":(name: "Uzbekistan", flag: "🇺🇿", callingCode: 998),
        "VA":(name: "Vatican", flag: "🇻🇦", callingCode: 379),
        "VC":(name: "Saint Vincent and the Grenadines", flag: "🇻🇨", callingCode: 784),
        "VE":(name: "Venezuela", flag: "🇻🇪", callingCode: 58),
        "VG":(name: "British Virgin Islands", flag: "🇻🇬", callingCode: 1),
        "VI":(name: "U.S. Virgin Islands", flag: "🇻🇮", callingCode: 1),
        "VN":(name: "Vietnam", flag: "🇻🇳", callingCode: 84),
        "VU":(name: "Vanuatu", flag: "🇻🇺", callingCode: 678),
        "WF":(name: "Wallis and Futuna", flag: "🇼🇫", callingCode: 681),
        "WS":(name: "Samoa", flag: "🇼🇸", callingCode: 685),
        "YE":(name: "Yemen", flag: "🇾🇪", callingCode: 967),
        "YT":(name: "Mayotte", flag: "🇾🇹", callingCode: 262),
        "ZA":(name: "South Africa", flag: "🇿🇦", callingCode: 27),
        "ZM":(name: "Zambia", flag: "🇿🇲", callingCode: 260),
        "ZW":(name: "Zimbabwe", flag: "🇿🇼", callingCode: 263),
    ]
}
