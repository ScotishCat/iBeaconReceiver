import UIKit

class AnimatedLockView: UIView {
    
    private var arcLayer: CAShapeLayer = CAShapeLayer()
    private var roundLayer: CAShapeLayer = CAShapeLayer()
    private var rectangleLayer: CAShapeLayer = CAShapeLayer()
    private var ovalLayer: CAShapeLayer = CAShapeLayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        drawLockLayers()
    }
    
    private func drawLockLayers() {
        self.arcLayer.removeFromSuperlayer()
        self.roundLayer.removeFromSuperlayer()
        self.rectangleLayer.removeFromSuperlayer()
        self.ovalLayer.removeFromSuperlayer()
        
        let width = self.frame.size.width/2 // sides of main rectangle
        let height = self.frame.size.height/2
        let outerRadius = self.frame.size.width/5
        let innerRadius = self.frame.size.width/10
        
        // complex arc
        self.arcLayer = CAShapeLayer()
        arcLayer.frame = CGRect(x: width - outerRadius, y: height - outerRadius, width: outerRadius*2, height: outerRadius)
        let complexArcPath = UIBezierPath()
        complexArcPath.addArc(withCenter: CGPoint(x: arcLayer.bounds.width/2, y: arcLayer.bounds.height), radius: outerRadius, startAngle: CGFloat(180.0).degreesToRadians, endAngle: CGFloat(360.0).degreesToRadians, clockwise: true)
        complexArcPath.addLine(to: CGPoint(x: arcLayer.bounds.width, y: arcLayer.bounds.height +  width/2))
        complexArcPath.addLine(to: CGPoint(x: arcLayer.bounds.width - outerRadius + innerRadius, y: arcLayer.bounds.height +  width/2))
        complexArcPath.addLine(to: CGPoint(x: arcLayer.bounds.width - outerRadius + innerRadius, y: arcLayer.bounds.height))
        complexArcPath.addArc(withCenter: CGPoint(x: arcLayer.bounds.width/2, y: arcLayer.bounds.height), radius: innerRadius, startAngle: CGFloat(0.0).degreesToRadians, endAngle: CGFloat(180.0).degreesToRadians, clockwise: false)
        complexArcPath.addLine(to: CGPoint(x: outerRadius - innerRadius, y: arcLayer.bounds.height))
        complexArcPath.close()

        complexArcPath.usesEvenOddFillRule = true
        arcLayer.strokeColor = UIColor.white.cgColor
        arcLayer.lineWidth = 5.0
        arcLayer.fillColor = self.backgroundColor?.cgColor
        arcLayer.path = complexArcPath.cgPath
        self.layer.addSublayer(arcLayer)
        
        // main rect area
        self.rectangleLayer = CAShapeLayer()
        let rect = CGRect(x: width/2, y: height, width: width, height: width)
        rectangleLayer.frame = rect
        let rectPath = UIBezierPath(roundedRect: rectangleLayer.bounds, cornerRadius: 15.0)
        rectangleLayer.strokeColor = UIColor.white.cgColor
        rectangleLayer.lineWidth = 5.0
        rectangleLayer.path = rectPath.cgPath
        rectangleLayer.fillColor = self.backgroundColor?.cgColor
        self.layer.addSublayer(rectangleLayer)
        
        // oval holder in the center of the lock
        let ovalRectWidth = self.frame.size.width/6
        let ovalRectHeight = self.frame.height/20
        self.ovalLayer = CAShapeLayer()
        let ovalRect = CGRect(x: width - ovalRectWidth/2, y: height + width/2 - ovalRectHeight/2, width: ovalRectWidth, height: ovalRectHeight)
        ovalLayer.frame = ovalRect
        let ovalPath = UIBezierPath(roundedRect: ovalLayer.bounds, cornerRadius: 25)
        ovalLayer.strokeColor = UIColor.white.cgColor
        ovalLayer.lineWidth = 5.0
        ovalLayer.fillColor = self.backgroundColor?.cgColor
        ovalLayer.path = ovalPath.cgPath
        self.layer.addSublayer(ovalLayer)
        
        // rounded rect in the oval holder
        self.roundLayer = CAShapeLayer()
        let roundRect = CGRect(x: width - ovalRectWidth/2, y: height + width/2 - ovalRectHeight/2, width: ovalRectHeight, height: ovalRectHeight)
        roundLayer.frame = roundRect
        let roundPath = UIBezierPath(roundedRect: roundLayer.bounds, cornerRadius: 25)
        roundLayer.strokeColor = UIColor.white.cgColor
        roundLayer.lineWidth = 5.0
        roundLayer.fillColor = self.backgroundColor?.cgColor
        roundLayer.path = roundPath.cgPath
        self.layer.addSublayer(roundLayer)
        
    }
    
    public func unlock() {
        
        let width = self.frame.size.width/2
        let height = self.frame.size.height/2
        let outerRadius = self.frame.size.width/5
        let ovalRectWidth = self.frame.size.width/6
        
        // round animations
        let roundAnimation = CASpringAnimation(keyPath: "position.x")
        roundAnimation.fromValue = roundLayer.position
        roundAnimation.toValue = width + ovalRectWidth/4
        roundAnimation.duration = 1
        roundAnimation.damping = 6
        roundAnimation.fillMode = kCAFillModeForwards
        roundAnimation.isRemovedOnCompletion = false
        
        let roundColorAnimation = CABasicAnimation(keyPath: "fillColor")
        roundColorAnimation.fromValue = roundLayer.fillColor
        roundColorAnimation.toValue = UIColor.white.cgColor
        roundColorAnimation.duration = 0.5
        roundColorAnimation.fillMode = kCAFillModeForwards
        roundColorAnimation.isRemovedOnCompletion = false

        // arc animations
        arcLayer.anchorPoint = CGPoint(x: 1, y: 1)
        arcLayer.position = CGPoint(x: width + outerRadius, y: height)

        let arcAnimation = CASpringAnimation(keyPath: "transform")
        let destinationTransform = CATransform3DRotate(arcLayer.transform, CGFloat.pi/8, 0.0, 0.0, 1.0)
        arcAnimation.fromValue = arcLayer.transform
        arcAnimation.toValue = destinationTransform
        arcAnimation.duration = 2
        arcAnimation.damping = 6
        arcAnimation.beginTime = CACurrentMediaTime() + 0.3
        arcAnimation.isRemovedOnCompletion = false
        arcAnimation.fillMode = kCAFillModeForwards

        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [roundAnimation, roundColorAnimation]
        self.arcLayer.add(arcAnimation, forKey: "arcAnimation")
        self.roundLayer.add(roundAnimation, forKey: "roundAnimation")
        self.roundLayer.add(roundColorAnimation, forKey: "backgroundColorAnimation")
        
    }
    
    public func lock() {
        
        let width = self.frame.size.width/2
        let height = self.frame.size.height/2
        let outerRadius = self.frame.size.width/5
        let ovalRectWidth = self.frame.size.width/6
        
        // round animations
        let roundAnimation = CASpringAnimation(keyPath: "position.x")
        roundAnimation.fromValue = roundLayer.position
        roundAnimation.toValue = width - ovalRectWidth/4
        roundAnimation.duration = 1
        roundAnimation.damping = 6
        roundAnimation.beginTime = CACurrentMediaTime() + 0.3
        roundAnimation.fillMode = kCAFillModeForwards
        roundAnimation.isRemovedOnCompletion = false
        
        let roundColorAnimation = CABasicAnimation(keyPath: "fillColor")
        roundColorAnimation.fromValue = roundLayer.fillColor
        roundColorAnimation.toValue = self.layer.backgroundColor
        roundColorAnimation.duration = 0.5
        roundColorAnimation.fillMode = kCAFillModeForwards
        roundColorAnimation.isRemovedOnCompletion = false
        
        // arc animations
        arcLayer.anchorPoint = CGPoint(x: 1, y: 1)
        arcLayer.position = CGPoint(x: width + outerRadius, y: height)
        
        let arcAnimation = CABasicAnimation(keyPath: "transform")
        let destinationTransform = CATransform3DRotate(arcLayer.transform, 0, 0.0, 0.0, 1.0)
        arcAnimation.fromValue = arcLayer.transform
        arcAnimation.toValue = destinationTransform
        arcAnimation.duration = 2
        arcAnimation.isRemovedOnCompletion = false
        arcAnimation.fillMode = kCAFillModeForwards
        
        self.arcLayer.add(arcAnimation, forKey: "arcAnimation")
        self.roundLayer.add(roundAnimation, forKey: "roundAnimation")
        self.roundLayer.add(roundColorAnimation, forKey: "backgroundColorAnimation")
        
    }
}

extension BinaryInteger {
    var degreesToRadians: CGFloat { return CGFloat(Int(self)) * .pi / 180 }
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

