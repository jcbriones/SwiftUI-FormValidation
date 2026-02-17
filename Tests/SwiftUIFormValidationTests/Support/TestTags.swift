import Testing

extension Tag {
    enum FormValidation {}
}

extension Tag.FormValidation {
    @Tag static var unit: Tag
    @Tag static var integration: Tag
    @Tag static var localization: Tag
    @Tag static var validator: Tag
    @Tag static var view: Tag
    @Tag static var extensionMethods: Tag
}
