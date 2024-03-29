//
//  ViewController.swift
//  Project27
//
//  Created by Ignacio Cervino on 02/03/2023.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var currentDrawType = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        drawRectangle()
    }


    @IBAction func redrawTapped(_ sender: Any) {
        currentDrawType += 1

        if currentDrawType > 7 {
            currentDrawType = 0
        }

        switch currentDrawType {
        case 0: drawRectangle()
        case 1: drawCircle()
        case 2: drawCheckerboard()
        case 3: drawRotatedSquares()
        case 4: drawLines()
        case 5: drawImagesAndText()
        case 6: drawEmoji()
        case 7: spellTwin()
        default: break
        }
    }

    func drawRectangle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

        let image = renderer.image { ctx in
            // draw code here
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)

            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10) // center of the edge of the rectangle

            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }

        imageView.image = image
    }

    func drawCircle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

        let image = renderer.image { ctx in
            // draw code here
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5) // method that lets us push each edge in by a certain amount.

            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10) // center of the edge of the rectangle

            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }

        imageView.image = image
    }

    func drawCheckerboard() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

        let image = renderer.image { ctx in
            // draw code here
            ctx.cgContext.setFillColor(UIColor.black.cgColor)

            for row in 0 ..< 8 {
                for col in 0 ..< 8 {
                    if (row + col).isMultiple(of: 2) {
                        // Fill just fills the rectangle at the parameter skipping the draw process
                        ctx.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
                    }
                }
            }
        }

        imageView.image = image
    }

    func drawRotatedSquares() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

        let image = renderer.image { ctx in
            // draw code here
            ctx.cgContext.translateBy(x: 256, y: 256) // Moves the center of our canvas

            let rotation = 16
            let amount = Double.pi / Double(rotation)

            for _ in 0 ..< rotation {
                ctx.cgContext.rotate(by: CGFloat(amount))
                ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
            }

            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }

        imageView.image = image
    }

    func drawLines() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

        let image = renderer.image { ctx in
            // draw code here
            ctx.cgContext.translateBy(x: 256, y: 256)

            var first = true
            var length: CGFloat = 256

            for _ in 0 ..< 256 {
                ctx.cgContext.rotate(by: .pi / 2)
                if first {
                    ctx.cgContext.move(to: CGPoint(x: length, y: 50))
                    first = false
                } else {
                    ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
                }

                length *= 0.99
            }

            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }

        imageView.image = image
    }

    func drawImagesAndText() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

        let image = renderer.image { ctx in
            // draw code here
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle
            ]

            let string = "The best-laid schemes o'\nmice an' men gang aft agley"

            let attributedString = NSAttributedString(string: string, attributes: attrs)
            attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options:  .usesLineFragmentOrigin, context: nil)

            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
        }

        imageView.image = image
    }

    /**
     Challenge 1: Pick any emoji and try creating it using Core Graphics. You should find some easy enough, but for a harder challenge you could also try something like the star emoji.
     */
    func drawEmoji() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

        let image = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            let leftEye = CGRect(x: 175, y: 150, width: 50, height: 80)
            let rightEye = CGRect(x: 287, y: 150, width: 50, height: 80)
            let smile = CGRect(x: 231, y: 350, width: 50, height: 50)

            ctx.cgContext.setFillColor(UIColor.yellow.cgColor)
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fill)

            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            ctx.cgContext.addEllipse(in: smile)
            ctx.cgContext.drawPath(using: .fill)

            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            ctx.cgContext.addEllipse(in: leftEye)
            ctx.cgContext.drawPath(using: .fill)

            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            ctx.cgContext.addEllipse(in: rightEye)
            ctx.cgContext.drawPath(using: .fill)
        }

        imageView.image = image
    }

    /**
     Challenge 2: Use a combination of move(to:) and addLine(to:) to create and stroke a path that spells “TWIN” on the canvas.
     */
    func spellTwin() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

        let image = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)

            ctx.cgContext.setStrokeColor(UIColor.white.cgColor)
            ctx.cgContext.setLineWidth(3)

            let upperY = CGFloat(200)
            let lowerY = CGFloat(350)
            let startX = CGFloat(50)

            // draw the T
            ctx.cgContext.move(to: CGPoint(x: startX, y: upperY))
            ctx.cgContext.addLine(to: CGPoint(x: startX + 130, y: upperY))
            ctx.cgContext.move(to: CGPoint(x: startX + 65, y: upperY))
            ctx.cgContext.addLine(to: CGPoint(x: startX + 65, y: lowerY))

            // draw the W
            ctx.cgContext.move(to: CGPoint(x: startX + 140, y: upperY))
            ctx.cgContext.addLine(to: CGPoint(x: startX + 165, y: lowerY))
            ctx.cgContext.move(to: CGPoint(x: startX + 165, y: lowerY))
            ctx.cgContext.addLine(to: CGPoint(x: startX + 180, y: lowerY - 75))
            ctx.cgContext.move(to: CGPoint(x: startX + 180, y: lowerY - 75))
            ctx.cgContext.addLine(to: CGPoint(x: startX + 205, y: lowerY))
            ctx.cgContext.move(to: CGPoint(x: startX + 205, y: lowerY))
            ctx.cgContext.addLine(to: CGPoint(x: startX + 225, y: upperY))

            // draw the I
            ctx.cgContext.move(to: CGPoint(x: startX + 255, y: upperY))
            ctx.cgContext.addLine(to: CGPoint(x: startX + 255, y: lowerY))

            // draw the N
            ctx.cgContext.move(to: CGPoint(x: startX + 285, y: lowerY))
            ctx.cgContext.addLine(to: CGPoint(x: startX + 285, y: upperY))

            ctx.cgContext.move(to: CGPoint(x: startX + 285, y: upperY))
            ctx.cgContext.addLine(to: CGPoint(x: startX + 335, y: lowerY))

            ctx.cgContext.move(to: CGPoint(x: startX + 335, y: upperY))
            ctx.cgContext.addLine(to: CGPoint(x: startX + 335, y: lowerY))

            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }

        imageView.image = image
    }

}

