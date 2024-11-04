abzTestTask

This repository contains the abzTestTask project, a SwiftUI-based application that demonstrates a sign-up flow using REST APIs. The app validates user information, manages photo uploads, and interacts with external APIs to register users and retrieve positions.
Table of Contents
•	Configuration Parameters
•	Dependencies
•	Troubleshooting
•	External API and Libraries Documentation
•	Code Structure
 
Configuration Parameters

The project uses certain environment-based configurations and API tokens for functionality. Here’s how to set up the configuration:
1.	Base API URL: Ensure the correct API base URL is configured. In this project, the API base URL is defined in the Endpoints enum.


enum Endpoints: String {
    case base = "https://frontend-test-assignment-api.abz.agency/api/v1"
    case token = "/token"
    case users = "/users"
    case positions = "/positions"
}
2.	Token Management: The app fetches and caches a token valid for 40 minutes. The UserAPIManager class manages token validity and refreshes it when expired. No additional configuration is needed for token management; the app handles this automatically.
3.	Image Upload Configuration: The photo upload in the sign-up form requires images in JPEG format. The image size must not exceed 5MB, and the minimum resolution is 70x70 pixels. Images that do not meet these requirements will not be uploaded successfully.
 
Dependencies

This project uses the following external libraries and frameworks:
•	SwiftUI: The main framework for building user interfaces declaratively on iOS.
•	Combine: For managing asynchronous tasks and reactive programming.
•	PhotosUI: For managing photo selection and handling image uploads in the sign-up form.
Note: Currently, this project doesn’t include any third-party package dependencies. All features are implemented with native Apple frameworks.
 
Troubleshooting

Below are some common issues and solutions:
1.	Network Connection Error:
o	Ensure that your device or simulator has an active internet connection.
o	If the "No Internet Connection" screen appears incorrectly, check the NetworkManager to ensure that it accurately detects the connection status.
2.	Invalid Email Format:
o	The email format validation follows RFC 2822 standards. Ensure that the email is correctly formatted. Example: user@example.com.
3.	Token Expiration:
o	Tokens expire every 40 minutes. The app automatically fetches a new token when needed. If registration fails due to an expired token, check that the fetchTokenIfNeeded method in UserAPIManager correctly fetches a new token when expired.
4.	Photo Upload Fails:
o	Ensure the photo meets the requirements: JPEG format, under 5MB, and at least 70x70 pixels.
o	If uploading from the simulator, ensure it has access to Photos or use placeholder images.
 
External API and Libraries Documentation

External APIs

1.	Token API (/token): This API provides a token required for registration requests. Tokens are valid for 40 minutes. This API is used to avoid repetitive authentication steps during registration.
2.	Users API (/users): This API allows fetching paginated user data and creating new user entries. It requires the token for authentication and handles multipart form-data for user registration.
3.	Positions API (/positions): This API retrieves a list of available positions, which are displayed as options in the sign-up form. Each position has a unique ID, which is required in the user registration request.
Why these APIs were used: These APIs provide the necessary data for user registration, including token authentication, position listing, and user creation. They were selected for their simplicity and alignment with the app’s functionality requirements.

Libraries

1.	SwiftUI: Used for building declarative user interfaces in iOS. SwiftUI is chosen for its simplicity and integration with Combine, making it easy to manage state across the app.
2.	Combine: Used for managing asynchronous tasks and handling API calls with reactive bindings. It simplifies handling multiple API requests and updating views automatically.
3.	PhotosUI: Used for photo selection in the sign-up form. It provides native functionality for accessing and managing photo libraries, making it easy for users to upload profile pictures.
Why these libraries were used: Native SwiftUI, Combine, and PhotosUI provide robust tools for building a declarative, reactive, and user-friendly experience without requiring additional dependencies.

Code Structure

API Layer

•	APIManager.swift: A base class that provides core functionality for making API requests, including handling HTTP methods, headers, and response processing.
•	UserAPIManager.swift: Extends APIManager to handle user-specific API interactions, such as fetching tokens, retrieving users, and registering new users.
•	Endpoints.swift: Defines API endpoints as constants, providing a centralized location for managing API URL paths.

Models

•	User.swift: Defines the User model, structured to match the API’s response for user data, including fields such as id, name, email, and registration details.
•	Position.swift: Represents a job position, including properties for the position’s id and name, used when selecting the user’s role.
•	TokenResponse.swift: The model for handling the token response from the API, storing the access token needed for authenticated requests.

ViewModels

•	SignUpViewModel.swift: Manages data and business logic for the sign-up flow. This includes field validation, form state management, and API interactions for registering a user.
•	UsersViewModel.swift: Handles the logic for loading and paginating users, including fetching additional users as the list is scrolled and managing loading states.

Views

•	SignUpView.swift: The primary view for user registration, displaying input fields, position selection, and a photo upload option.
•	UsersView.swift: A list-based view that displays registered users with pagination, loading additional users as the user scrolls down.
•	CustomTextField.swift: A custom text field component with built-in validation, used in forms to simplify input handling and error display.
•	RadioButton.swift: A custom component for displaying selectable radio buttons, used to choose a position in the sign-up view.
•	ReusableScreen.swift: A reusable view component designed to display error and success messages consistently across the app.

Resources

•	Assets.xcassets: A folder containing all the images and icons used in the app, such as icons for buttons and background images for reusable screens.
This structure follows the MVVM pattern, separating data models, business logic, and UI components to ensure a clean and maintainable codebase.

Important Modules

1.	APIManager: A base class responsible for making API requests and handling responses. It contains shared logic for handling headers and errors across different API calls.
2.	UserAPIManager: Extends APIManager and includes methods specifically for fetching users, positions, and tokens. It also handles token expiration logic.
3.	SignUpViewModel: Handles the state and logic for the sign-up screen. This view model includes field validation, form submission, and error handling. It communicates with UserAPIManager to register users and retrieve token data when needed.
4.	UsersViewModel: Manages the state and data for the users list. It handles pagination and fetches additional user data when the user scrolls to the end of the list.
5.	ReusableScreen: A reusable screen component used to display network errors or success messages, maintaining consistency in the app’s error-handling UI.
6.	CustomTextField: A customizable text field component that supports validation. It displays error messages and formats text according to the field type.

