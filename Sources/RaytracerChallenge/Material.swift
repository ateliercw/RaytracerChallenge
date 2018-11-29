import Foundation

public struct Material: Equatable, Hashable {
    public var color: Color
    public var ambient: Float
    public var diffuse: Float
    public var specular: Float
    public var shininess: Float

    public init(color: Color = .white,
                ambient: Float = 0.1,
                diffuse: Float = 0.9,
                specular: Float = 0.9,
                shininess: Float = 200) {
        self.color = color
        self.ambient = ambient
        self.diffuse = diffuse
        self.specular = specular
        self.shininess = shininess
    }

    public func lighting(light: PointLight, position: Tuple, eyeVector: Tuple, normalVector: Tuple) -> Color {
        assert(eyeVector.isVector)
        assert(normalVector.isVector)
        let effectiveColor = color * light.intensity

        let lightVector = (light.position - position).normalized

        let ambientColor = effectiveColor * ambient

        // lightDotNormal is the cosine of the angle between light vector
        // and normal vector. A negative number means the
        // light is on the other side of the surface
        let lightDotNormal = lightVector.dot(normalVector)
        guard lightDotNormal >= 0 else { return ambientColor }

        let diffuseColor = effectiveColor * diffuse * lightDotNormal

        // reflectDotEye represents the cosine of the angle between the
        // reflection vector and the eve vector. A negative number means the
        // light reflects away from the eye
        let reflectionVector = -lightVector.reflect(normalVector)
        let reflectDotEye = reflectionVector.dot(eyeVector)
        let specularColor: Color
        if reflectDotEye < 0 {
            specularColor = .black
        } else {
            let factor = pow(reflectDotEye, shininess)
            specularColor = light.intensity * specular * factor
        }

        return ambientColor + diffuseColor + specularColor
    }
}
