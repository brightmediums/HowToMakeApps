//
//  Element.swift
//  Elements
//
//  Created by Joshua Stephenson on 5/19/18.
//  Copyright © 2018 Bright Mediums. All rights reserved.
//

import UIKit

class Element: NSObject {
    var symbol: String
    var name: String
    var weight: NSNumber
    
    init(symbol: String, name: String, weight: NSNumber){
        self.symbol = symbol
        self.name = name
        self.weight = weight
    }
    
    static func getAllElements() -> [Element] {
        return elementAttributes.map({ attributes in
            let weightDouble = (attributes["weight"]! as NSString).doubleValue
            let weightNumber = NSNumber(value: weightDouble)
            return Element(symbol: attributes["symbol"]!, name: attributes["name"]!, weight: weightNumber)
        })
    }
    
    static let elementAttributes = [
        ["weight":"1.008","name":"Hydrogen","symbol":"H"],
        ["weight":"4.003","name":"Helium","symbol":"He"],
        ["weight":"6.941","name":"Lithium","symbol":"Li"],
        ["weight":"9.012","name":"Beryllium","symbol":"Be"],
        ["weight":"10.811","name":"Boron","symbol":"B"],
        ["weight":"12.011","name":"Carbon","symbol":"C"],
        ["weight":"14.007","name":"Nitrogen","symbol":"N"],
        ["weight":"15.999","name":"Oxygen","symbol":"O"],
        ["weight":"18.998","name":"Fluorine","symbol":"F"],
        ["weight":"20.180","name":"Neon","symbol":"Ne"],
        ["weight":"22.990","name":"Sodium","symbol":"Na"],
        ["weight":"24.305","name":"Magnesium","symbol":"Mg"],
        ["weight":"26.982","name":"Aluminum","symbol":"Al"],
        ["weight":"28.086","name":"Silicon","symbol":"Si"],
        ["weight":"30.974","name":"Phosphorus","symbol":"P"],
        ["weight":"32.065","name":"Sulfur","symbol":"S"],
        ["weight":"35.453","name":"Chlorine","symbol":"Cl"],
        ["weight":"39.948","name":"Argon","symbol":"Ar"],
        ["weight":"39.098","name":"Potassium","symbol":"K"],
        ["weight":"40.078","name":"Calcium","symbol":"Ca"],
        ["weight":"44.956","name":"Scandium","symbol":"Sc"],
        ["weight":"47.867","name":"Titanium","symbol":"Ti"],
        ["weight":"50.942","name":"Vanadium","symbol":"V"],
        ["weight":"51.996","name":"Chromium","symbol":"Cr"],
        ["weight":"54.938","name":"Manganese","symbol":"Mn"],
        ["weight":"55.845","name":"Iron","symbol":"Fe"],
        ["weight":"58.933","name":"Cobalt","symbol":"Co"],
        ["weight":"58.693","name":"Nickel","symbol":"Ni"],
        ["weight":"63.546","name":"Copper","symbol":"Cu"],
        ["weight":"65.390","name":"Zinc","symbol":"Zn"],
        ["weight":"69.723","name":"Gallium","symbol":"Ga"],
        ["weight":"72.640","name":"Germanium","symbol":"Ge"],
        ["weight":"74.922","name":"Arsenic","symbol":"As"],
        ["weight":"78.960","name":"Selenium","symbol":"Se"],
        ["weight":"79.904","name":"Bromine","symbol":"Br"],
        ["weight":"83.800","name":"Krypton","symbol":"Kr"],
        ["weight":"85.468","name":"Rubidium","symbol":"Rb"],
        ["weight":"87.620","name":"Strontium","symbol":"Sr"],
        ["weight":"88.906","name":"Yttrium","symbol":"Y"],
        ["weight":"91.224","name":"Zirconium","symbol":"Zr"],
        ["weight":"92.906","name":"Niobium","symbol":"Nb"],
        ["weight":"95.940","name":"Molybdenum","symbol":"Mo"],
        ["weight":"98.000","name":"Technetium","symbol":"Tc"],
        ["weight":"101.070","name":"Ruthenium","symbol":"Ru"],
        ["weight":"102.906","name":"Rhodium","symbol":"Rh"],
        ["weight":"106.420","name":"Palladium","symbol":"Pd"],
        ["weight":"107.868","name":"Silver","symbol":"Ag"],
        ["weight":"112.411","name":"Cadmium","symbol":"Cd"],
        ["weight":"114.818","name":"Indium","symbol":"In"],
        ["weight":"118.710","name":"Tin","symbol":"Sn"],
        ["weight":"121.760","name":"Antimony","symbol":"Sb"],
        ["weight":"127.600","name":"Tellurium","symbol":"Te"],
        ["weight":"126.905","name":"Iodine","symbol":"I"],
        ["weight":"131.293","name":"Xenon","symbol":"Xe"],
        ["weight":"132.906","name":"Cesium","symbol":"Cs"],
        ["weight":"137.327","name":"Barium","symbol":"Ba"],
        ["weight":"138.906","name":"Lanthanum","symbol":"La"],
        ["weight":"140.116","name":"Cerium","symbol":"Ce"],
        ["weight":"140.908","name":"Praseodymium","symbol":"Pr"],
        ["weight":"144.240","name":"Neodymium","symbol":"Nd"],
        ["weight":"145.000","name":"Promethium","symbol":"Pm"],
        ["weight":"150.360","name":"Samarium","symbol":"Sm"],
        ["weight":"151.964","name":"Europium","symbol":"Eu"],
        ["weight":"157.250","name":"Gadolinium","symbol":"Gd"],
        ["weight":"158.925","name":"Terbium","symbol":"Tb"],
        ["weight":"162.500","name":"Dysprosium","symbol":"Dy"],
        ["weight":"164.930","name":"Holmium","symbol":"Ho"],
        ["weight":"167.259","name":"Erbium","symbol":"Er"],
        ["weight":"168.934","name":"Thulium","symbol":"Tm"],
        ["weight":"173.040","name":"Ytterbium","symbol":"Yb"],
        ["weight":"174.967","name":"Lutetium","symbol":"Lu"],
        ["weight":"178.490","name":"Hafnium","symbol":"Hf"],
        ["weight":"180.948","name":"Tantalum","symbol":"Ta"],
        ["weight":"183.840","name":"Tungsten","symbol":"W"],
        ["weight":"186.207","name":"Rhenium","symbol":"Re"],
        ["weight":"190.230","name":"Osmium","symbol":"Os"],
        ["weight":"192.217","name":"Iridium","symbol":"Ir"],
        ["weight":"195.078","name":"Platinum","symbol":"Pt"],
        ["weight":"196.967","name":"Gold","symbol":"Au"],
        ["weight":"200.590","name":"Mercury","symbol":"Hg"],
        ["weight":"204.383","name":"Thallium","symbol":"Tl"],
        ["weight":"207.200","name":"Lead","symbol":"Pb"],
        ["weight":"208.980","name":"Bismuth","symbol":"Bi"],
        ["weight":"209.000","name":"Polonium","symbol":"Po"],
        ["weight":"210.000","name":"Astatine","symbol":"At"],
        ["weight":"222.000","name":"Radon","symbol":"Rn"],
        ["weight":"223.000","name":"Francium","symbol":"Fr"],
        ["weight":"226.000","name":"Radium","symbol":"Ra"],
        ["weight":"227.000","name":"Actinium","symbol":"Ac"],
        ["weight":"232.038","name":"Thorium","symbol":"Th"],
        ["weight":"231.036","name":"Protactinium","symbol":"Pa"],
        ["weight":"238.029","name":"Uranium","symbol":"U"],
        ["weight":"237.000","name":"Neptunium","symbol":"Np"],
        ["weight":"244.000","name":"Plutonium","symbol":"Pu"],
        ["weight":"243.000","name":"Americium","symbol":"Am"],
        ["weight":"247.000","name":"Curium","symbol":"Cm"],
        ["weight":"247.000","name":"Berkelium","symbol":"Bk"],
        ["weight":"251.000","name":"Californium","symbol":"Cf"],
        ["weight":"252.000","name":"Einsteinium","symbol":"Es"],
        ["weight":"257.000","name":"Fermium","symbol":"Fm"],
        ["weight":"258.000","name":"Mendelevium","symbol":"Md"],
        ["weight":"259.000","name":"Nobelium","symbol":"No"],
        ["weight":"262.000","name":"Lawrencium","symbol":"Lr"],
        ["weight":"261.000","name":"Rutherfordium","symbol":"Rf"],
        ["weight":"262.000","name":"Dubnium","symbol":"Db"],
        ["weight":"266.000","name":"Seaborgium","symbol":"Sg"],
        ["weight":"264.000","name":"Bohrium","symbol":"Bh"],
        ["weight":"277.000","name":"Hassium","symbol":"Hs"],
        ["weight":"268.000","name":"Meitnerium","symbol":"Mt"]
    ]
}
