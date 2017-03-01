import HTTP

public enum ClientsError: Error {
    case badResponse(Status)
    case unspecified(Error)
}
