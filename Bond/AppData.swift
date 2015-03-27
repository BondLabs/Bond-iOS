//
//  AppData.swift
//  Bond
//
//  Created by Kevin Zhang on 1/3/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

import UIKit

struct bondColors {
    static let color1 = AppData.util.UIColorFromRGB(0x008ad7)
    static let color2 = AppData.util.UIColorFromRGB(0x50c1ff)
    static let color3 = AppData.util.UIColorFromRGB(0x1dafff)
    static let color4 = AppData.util.UIColorFromRGB(0x00a4ff)
}

enum barButtonType {
	case Title
	case button_big
	case button_small
}

func errorLog(x: AnyObject) {
	println("BOND messed up. Threw this error: \(x)")
}

func bondLog(x: AnyObject) {
	println("\(x)")
}

func kevinLog(x: AnyObject) {
	bondLog("Kevin: \(x)")
}

func bryceLog(x: AnyObject) {
	bondLog("Bryce: \(x)")
}

func misbahLog(x: AnyObject) {
	bondLog("Misbah: \(x)")
}

func danielLog(x: AnyObject) {
	bondLog("Daniel: \(x)")
}

var screenSize: CGSize {
    return UIScreen.mainScreen().bounds.size
}



func try(try:()->())->TryCatchFinally {
	return TryCatchFinally(try)
}

infix operator =~ {}

func =~ (input: String, pattern: String) -> Bool {
	return Regex(pattern).test(input)
}
/*
func * (input: Int, pattern: CGFloat) -> CGFloat {
	return CGFloat(input) * pattern
}

func * (input: CGFloat, pattern: Int) -> CGFloat {
	return input * CGFloat(pattern)
}

func / (input: Int, pattern: CGFloat) -> CGFloat {
	return CGFloat(input) / pattern
}

func / (input: CGFloat, pattern: Int) -> CGFloat {
	return input / CGFloat(pattern)
}
*/


infix operator & {}



func & (input: String, pattern: String) -> String {

	let error = NSError(domain: "com.bondlabs.bond.error", code: 404, userInfo: [NSLocalizedDescriptionKey : "lol"])

	var finalString = ""
	if countElements(input) == countElements(pattern) {
	for i in 0...(countElements(input) - 1) {

		let arrayChar = Array(input)[i]
		let patternChar = Array(pattern)[i]

		if arrayChar == patternChar {
			finalString.append(arrayChar)
		}
		else {
			finalString = finalString + "0"
		}
	}
	}
	else {
		error
		return ""
	}

	bondLog("combined \(input) and \(pattern)")

	return finalString


}


extension Bool {
    var intValue: Int {
        if self.boolValue {
            return 1
        }
        else {
            return 0
        }
    }
}

class AppData {
    
    class func bondLog(x: AnyObject) {
        NSLog("\(x)")
    }
	
    struct data {
        static var userID:Int!
		static var viewWidth = UIScreen.mainScreen().bounds.width
		struct heights {
			static var navBarHeight:CGFloat! =  UINavigationController().navigationBar.frame.height
			static var navViewHeight:CGFloat! = normViewHeight - navBarHeight
			static var normViewHeight:CGFloat! = UIScreen.mainScreen().bounds.height - statusBarHeight
			static var pageControlHeight:CGFloat! = 36.0
			static var statusBarHeight:CGFloat! = UIApplication.sharedApplication().statusBarFrame.height
			static var tabBarHeight:CGFloat! = UITabBarController().tabBar.frame.height
			static var tabBarViewHeight:CGFloat! = navViewHeight - tabBarHeight
		}
		static var activityNames:[String] = ["Active", "Artist", "Badass", "Brainy", "Caring", "Chill", "Creative", "Cultured", "Curious", "Driven", "Easygoing", "Empathetic", "Experienced", "Extroverted", "Fashionable", "Fit", "Free Spirited", "Friendly", "Fun", "Funky", "Hipster", "Introverted", "LOL", "Loud", "Modern", "Motivated", "Observant", "Ol'Skool", "Open Minded", "Outgoing", "Posh", "Rebellious", "Relaxed", "Romantic", "Rustic", "Sarcastic", "Serious", "Sporty", "Studious", "Thrilling", "Tough", "Traditional", "Trustworthy", "Visual", "Weird"]

		static let font = UIFont(name: "Avenir-Medium", size: 16.0)
    }


	struct errorStates {
		static let password = "Password must be more than four characters"
		static let phoneNumber = "Please provide a valid phone number"
	}


	
    struct util {
        static func UIColorFromRGB(rgbValue: UInt) -> UIColor {
            return UIColor(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
            )
        }
        
		static func UIColorFromRGBA(rgbValue: UInt, alphaValue: Float) -> UIColor {
			return UIColor(
				red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
				green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
				blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
				alpha: CGFloat(alphaValue)
			)
		}
		
		static func UIImageFromColor(color: UIColor) -> UIImage {
			UIGraphicsBeginImageContext(CGSizeMake(1, 1))
			color.setFill()
			var context = UIGraphicsGetCurrentContext()
			CGContextFillRect(context, CGRectMake(0, 0, 1, 1))
			var image = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			return image
		}

		static func scaleImage(image: UIImage, size: CGSize, scale: CGFloat) -> UIImage {
			var smallSize = CGSizeMake(size.width * scale, size.height * scale)
			UIGraphicsBeginImageContextWithOptions(smallSize, false, 0)
			image.drawInRect(CGRect(origin: CGPointZero, size: smallSize))
			var scaled:UIImage = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			return scaled
		}



		static func cropImage(image:UIImage, fromSize:CGSize, toSize:CGSize) -> UIImage {
			var cropCenter:CGPoint = CGPointMake(fromSize.width / 2, fromSize.height / 2)
			var cropStart:CGPoint = CGPointMake(cropCenter.x - toSize.width/2, cropCenter.y - toSize.height / 2)
			var cropRect:CGRect = CGRectMake(cropStart.x, cropStart.y, toSize.width, toSize.height)
			var cropRef:CGImageRef = CGImageCreateWithImageInRect(image.CGImage, cropRect)
			var cropImage:UIImage = UIImage(CGImage: cropRef)!
			return cropImage
		}
        
        static func convertToMM(user: Int) -> (Int, Int) {
            return (Int(user / 65536), Int(user % 65536))
        }
        
        static func convertToID(maj: Int, min: Int) -> Int {
            return maj * 65536 + min
        }
		static func getHeightForText(text: NSString, font: UIFont, size: CGSize) -> CGSize {

			var newSize = CGSizeZero

			let frame = text.boundingRectWithSize(size,
				options: NSStringDrawingOptions.UsesLineFragmentOrigin,
				attributes: [NSFontAttributeName: font], context: nil)

			newSize = CGSizeMake(frame.size.width, frame.size.height + 1)

			return newSize
		}
		static func getWidthForText(text: NSString, font: UIFont, size: CGSize) -> CGSize {

			var newSize = CGSizeZero

			let frame = text.boundingRectWithSize(size,
				options: NSStringDrawingOptions.UsesLineFragmentOrigin,
				attributes: [NSFontAttributeName: font], context: nil)

			newSize = CGSizeMake(frame.size.width, frame.size.height + 1)

			return newSize
		}

		static func imageWithColor(color: UIColor) -> UIImage {
			let rect = CGRectMake(0,0,1,1)
			UIGraphicsBeginImageContext(rect.size)
			let context = UIGraphicsGetCurrentContext();
			CGContextSetFillColorWithColor(context, color.CGColor);
			CGContextFillRect(context, rect);
			let image = UIGraphicsGetImageFromCurrentImageContext();
			UIGraphicsEndImageContext();

			return image

		}


    }
}

class Regex {
	let internalExpression: NSRegularExpression
	let pattern: String

	init(_ pattern: String) {
		self.pattern = pattern
		var error: NSError?
		self.internalExpression = NSRegularExpression(pattern: pattern, options: .CaseInsensitive, error: &error)!
	}

	func test(input: String) -> Bool {
		let matches = self.internalExpression.matchesInString(input, options: nil, range:NSMakeRange(0, countElements(input)))
		return matches.count > 0
	}
}


class TryCatchFinally {
	let tryFunc : ()->()
	var catchFunc = { (e:NSException!)->() in return }
	var finallyFunc : ()->() = {}

	init(_ try:()->()) {
		tryFunc = try
	}

	func catch(catch:(NSException)->())->TryCatchFinally {
		// objc bridging needs NSException!, not NSException as we'd like to expose to clients.
		catchFunc = { (e:NSException!) in catch(e) }
		return self
	}

	func finally(finally:()->()) {
		finallyFunc = finally
	}

	deinit {
		tryCatchFinally(tryFunc, catchFunc, finallyFunc)
	}
}


extension String {

    // MARK: - sub String
    func substringToIndex(index:Int) -> String {
        return self.substringToIndex(advance(self.startIndex, index))
    }
    func substringFromIndex(index:Int) -> String {
        return self.substringFromIndex(advance(self.startIndex, index))
    }
    func substringWithRange(range:Range<Int>) -> String {
        let start = advance(self.startIndex, range.startIndex)
        let end = advance(self.startIndex, range.endIndex)
        return self.substringWithRange(start..<end)
    }
    
    subscript(index:Int) -> Character{
        return self[advance(self.startIndex, index)]
    }
    subscript(range:Range<Int>) -> String {
        let start = advance(self.startIndex, range.startIndex)
        let end = advance(self.startIndex, range.endIndex)
        return self[start..<end]
    }
    
    // MARK: - replace
    func replaceCharactersInRange(range:Range<Int>, withString: String) -> String {
        var result:NSMutableString = NSMutableString(string: self)
        result.replaceCharactersInRange(NSRange(range), withString: withString)
        return result
    }
}

extension UIImage {
	func imageByApplyingAlpha(alpha: CGFloat) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(self.size, false, 0)
		let ctx = UIGraphicsGetCurrentContext()
		let area = CGRectMake(0, 0, self.size.width, self.size.height)
		CGContextScaleCTM(ctx, 1, -1);
		CGContextTranslateCTM(ctx, 0, -area.size.height);

		CGContextSetBlendMode(ctx, kCGBlendModeMultiply);

		CGContextSetAlpha(ctx, alpha);

		CGContextDrawImage(ctx, area, self.CGImage);

		let newImage = UIGraphicsGetImageFromCurrentImageContext();

		UIGraphicsEndImageContext();

		return newImage;

	}
}

extension NSObject {
	func safeUnwrap() -> NSObject {

		var object: NSObject?
		object = self

		if object != nil {
			return object!
		}
		else {
			NSLog("returned nil object, wtf dude")
			return NSObject()
		}


	}
}

extension Int {
	var FloatValue: Float {
		return Float(self)
	}
	var CGFloatValue: CGFloat {
		return CGFloat(self)
	}
}



