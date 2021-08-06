import CoreLocation
import Foundation
import NationalWeatherService

// Sample URL:
// https://api.openweathermap.org/data/2.5/weather?lat=51.50998&lon=-0.1337&appid=e6f124ac6b7d2fea7347932c86883958&units=metric
public final class WeatherService: NSObject {
    
    private let locationManager = CLLocationManager()
    private let API_KEY = "396d95ff373d9c8c0047867b8d31d361"
    private var completionHandler: ((Forecast?, CLPlacemark?, LocationAuthError?) -> Void)?
    private var dataTask: URLSessionDataTask?
    private let nws = NationalWeatherService(userAgent: "(SimpleWeather, sharansajivmenon@icloud.com)")
    
    public override init() {
        super.init()
        locationManager.delegate = self
    }
    
    public func loadWeatherData(
        _ completionHandler: @escaping((Forecast?, CLPlacemark?, LocationAuthError?) -> Void)
    ) {
        self.completionHandler = completionHandler
        loadDataOrRequestLocationAuth()
    }
    
    private func makeDataRequest(forCoordinates coordinates: CLLocation) {
        nws.forecast(for: coordinates) { result in
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(coordinates, completionHandler: { (placemarks, error) in
                switch result {
                case .success(let forecast): self.completionHandler?(forecast, placemarks?[0], nil)
                case .failure(let error):     print(error)
                }
            })
        }
    }
    
    private func loadDataOrRequestLocationAuth() {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            completionHandler?(nil,nil, LocationAuthError())
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

extension WeatherService: CLLocationManagerDelegate {
    public func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.first else { return }
        makeDataRequest(forCoordinates: location)
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        loadDataOrRequestLocationAuth()
    }
    public func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print("Something went wrong: \(error.localizedDescription)")
    }
}

struct APIResponse: Decodable {
    let name: String
    let main: APIMain
    let weather: [APIWeather]
}

struct APIMain: Decodable {
    let temp: Double
}

struct APIWeather: Decodable {
    let description: String
    let iconName: String
    
    enum CodingKeys: String, CodingKey {
        case description
        case iconName = "main"
    }
}

public struct LocationAuthError: Error {}
