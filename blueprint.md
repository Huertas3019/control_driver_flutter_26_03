# Blueprint del Portal de Clientes

## Descripción General

Este documento describe la arquitectura, el diseño y las características de la aplicación del Portal de Clientes. La aplicación está construida con Flutter y Firebase, y está diseñada para ser una aplicación multiplataforma (web, iOS, Android) que permite a los clientes gestionar sus servicios, ver facturas, obtener soporte y más.

## Arquitectura

La aplicación sigue una arquitectura limpia y en capas para la separación de intereses y la escalabilidad.

- **Presentación:** Construida con Flutter. Los widgets se utilizan para la interfaz de usuario, y el estado de la interfaz de usuario se gestiona mediante una combinación de `StatefulWidget` para el estado local y `Provider` para el estado de la aplicación.
- **Lógica de Negocio:** Encapsulada en `ChangeNotifier`s (Proveedores) que son proporcionados a la interfaz de usuario a través de `ChangeNotifierProvider`.
- **Datos:** Repositorios que abstraen las fuentes de datos (Firestore, Firebase Storage, etc.) de la lógica de negocio.
- **Enrutamiento:** Gestionado por el paquete `go_router` para habilitar la navegación declarativa, el enrutamiento basado en URL y los enlaces profundos.

## Estilo y Diseño

- **Tema:** La aplicación utiliza un tema profesional y sobrio con un esquema de color primario de azul oscuro (`0xFF1B2A41`). Se admiten los modos claro y oscuro.
- **Tipografía:** Las fuentes de Google se utilizan para un aspecto limpio y moderno. `Montserrat` para los encabezados y `Lato` para el cuerpo del texto.
- **Iconografía:** Se utilizan iconos de Material Design para la navegación y las acciones.

## Características

### Versión 1.0.0 (Inicial)

- **Autenticación:**
  - Integración con Firebase Authentication.
  - Inicio de sesión con Google a través de `firebase_ui_auth` y `firebase_ui_oauth_google`.
  - `AuthGate` para gestionar los estados de autenticación del usuario y redirigir a los usuarios a la pantalla de inicio de sesión o a la pantalla de inicio.
- **Tema:**
  - Proveedor de tema para cambiar entre los modos claro y oscuro.
  - Temas claro y oscuro definidos con `ColorScheme.fromSeed`.
  - `GoogleFonts` para una tipografía consistente.
- **Enrutamiento:**
  - Navegación gestionada por `go_router`.
  - Ruta inicial (`/`) que dirige a `AuthGate`.
  - Ruta de inicio (`/home`) para usuarios autenticados.
