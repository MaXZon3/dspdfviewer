# cmake frament

# External libraries


### Boost Libraries ###
if(BuildTests)
	# If we're building tests, we need program_options AND unit_test_framework
	find_package(Boost
		COMPONENTS program_options unit_test_framework
		REQUIRED)
else()
	# No unit tests: Only program_options needed
	find_package(Boost
		COMPONENTS program_options
		REQUIRED)
endif()


### Qt
if(UseQtFive)
	# Qt5
	message(STATUS "Using Qt5 and libpoppler-qt5")
	set(CMAKE_PREFIX_PATH "C:/Qt/Static/qtbase")
	find_package(Qt5Core 5.1.1 REQUIRED)
	# On lower versions, QTBUG-32100 prevents compilation at least on clang
	# https://bugreports.qt.io/browse/QTBUG-32100
	find_package(Qt5Gui REQUIRED)
	find_package(Qt5Widgets REQUIRED)
	find_package(Qt5LinguistTools REQUIRED)
  find_package(Qt5XML REQUIRED)
	#pkg_search_module(POPPLER REQUIRED poppler-qt5)
  set(POPPLER_LIBRARIES optimized "C:/dspdf/poppler/poppler/lib/poppler.lib" debug "C:/dspdf/poppler/poppler/lib/popplerd.lib" optimized "C:/dspdf/poppler/poppler/lib/poppler-qt5.lib" debug "C:/dspdf/poppler/poppler/lib/poppler-qt5d.lib" optimized "C:/dspdf/poppler/deps/cairo/lib/cairo-static.lib" debug "C:/dspdf/poppler/deps/cairo/lib/cairo-staticd.lib" optimized "C:/dspdf/poppler/deps/freetype/lib/freetype.lib" debug "C:/dspdf/poppler/deps/freetype/lib/freetyped.lib" optimized "C:/dspdf/poppler/deps/lcms/Lib/MS/lcms2_static.lib" debug "C:/dspdf/poppler/deps/lcms/Lib/MS/lcms2_staticd.lib" optimized "C:/dspdf/poppler/deps/fontconfig/lib/libfontconfig.lib" debug "C:/dspdf/poppler/deps/fontconfig/lib/libfontconfigd.lib" optimized "C:/dspdf/poppler/deps/libjpeg-turbo/lib/jpeg-static.lib" debug "C:/dspdf/poppler/deps/libjpeg-turbo/lib/jpeg-staticd.lib" optimized "C:/dspdf/poppler/deps/libpng/lib/libpng16_static.lib" debug "C:/dspdf/poppler/deps/libpng/lib/libpng16_staticd.lib" optimized "C:/dspdf/poppler/deps/libtiff/lib/tiff_static.lib" debug "C:/dspdf/poppler/deps/libtiff/lib/tiff_staticd.lib" optimized "C:/dspdf/poppler/deps/zlib/lib/zlibstatic.lib" debug "C:/dspdf/poppler/deps/zlib/lib/zlibstaticd.lib" optimized "C:/dspdf/poppler/deps/expat/lib/expat.lib" debug "C:/dspdf/poppler/deps/expat/lib/expatd.lib" optimized "C:/dspdf/poppler/deps/openjpeg/lib/openjp2.lib" debug "C:/dspdf/poppler/deps/openjpeg/lib/openjp2d.lib" optimized "C:/dspdf/poppler/deps/libtiff/lib/port.lib" debug "C:/dspdf/poppler/deps/libtiff/lib/portd.lib" optimized "C:/dspdf/poppler/deps/libiconv/lib/libiconvStatic.lib" debug "C:/dspdf/poppler/deps/libiconv/lib/libiconvStaticD.lib" optimized "C:/dspdf/poppler/deps/pixman/lib/pixman-1_static.lib" debug "C:/dspdf/poppler/deps/pixman/lib/pixman-1_staticd.lib")
	set(POPPLER_INCLUDE_DIRS "C:/dspdf/poppler/poppler/include/poppler/qt5")
	# add their include directories
	list(APPEND LIST_INCLUDE_DIRS ${Qt5Core_INCLUDE_DIRS} ${Qt5Gui_INCLUDE_DIRS} ${Qt5Widgets_INCLUDE_DIRS})
	# add their link flags
	list(APPEND LIST_LIBRARIES ${Qt5Core_LIBRARIES} ${Qt5Gui_LIBRARIES} ${Qt5Widgets_LIBRARIES} optimized "C:/Qt/Static/qtbase/lib/Qt5XML.lib" debug "C:/Qt/Static/qtbase/lib/Qt5XMLd.lib" optimized "C:/Qt/Static/qtbase/lib/Qt5PlatformSupport.lib" debug "C:/Qt/Static/qtbase/lib/Qt5PlatformSupportd.lib" optimized "C:/Qt/Static/qtbase/plugins/platforms/qwindows.lib" debug "C:/Qt/Static/qtbase/plugins/platforms/qwindowsd.lib" optimized "C:/Qt/Static/qtbase/lib/qtpcre.lib" debug "C:/Qt/Static/qtbase/lib/qtpcred.lib" optimized "C:/Qt/Static/qtbase/lib/qtharfbuzzng.lib" debug "C:/Qt/Static/qtbase/lib/qtharfbuzzngd.lib" "C:/Program Files (x86)/Microsoft SDKs/Windows/v7.1A/Lib/WS2_32.Lib" "C:/Program Files (x86)/Microsoft SDKs/Windows/v7.1A/Lib/OpenGL32.Lib" "C:/Program Files (x86)/Microsoft SDKs/Windows/v7.1A/Lib/MSImg32.Lib" "C:/Program Files (x86)/Microsoft SDKs/Windows/v7.1A/Lib/Imm32.Lib" "C:/Program Files (x86)/Microsoft SDKs/Windows/v7.1A/Lib/Winmm.Lib")
	add_definitions(-DPOPPLER_QT5)
	add_definitions(-fPIC)
	qt5_wrap_ui(dspdfviewer_UIS_H ${UIFILES})
	if( UpdateTranslations )
		qt5_create_translation(TRANSLATIONS ${dspdfviewer_SRCS} ${UIFILES} ${TRANSLATIONFILES})
	else()
		qt5_add_translation(TRANSLATIONS ${TRANSLATIONFILES})
	endif()
else()
	#qt4
	message(STATUS "Using Qt4 and libpoppler-qt4")
	find_package(Qt4 REQUIRED COMPONENTS QtCore QtGui)
	pkg_search_module(POPPLER REQUIRED poppler-qt4)

	list(APPEND LIST_INCLUDE_DIRS ${QT_INCLUDES})
	list(APPEND LIST_LIBRARIES Qt4::QtGui)
	qt4_wrap_ui(dspdfviewer_UIS_H ${UIFILES})
	if( UpdateTranslations )
		qt4_create_translation(TRANSLATIONS ${dspdfviewer_SRCS} ${UIFILES} ${TRANSLATIONFILES})
	else()
		qt4_add_translation(TRANSLATIONS ${TRANSLATIONFILES})
	endif()
endif()

# include/link poppler
list(APPEND LIST_LIBRARIES ${POPPLER_LIBRARIES})
list(APPEND LIST_INCLUDE_DIRS ${POPPLER_INCLUDE_DIRS})

list(APPEND LIST_INCLUDE_DIRS ${Boost_INCLUDE_DIRS})
list(APPEND LIST_LIBRARIES ${Boost_LIBRARIES})

# This is needed for moc/uic results
list(APPEND LIST_INCLUDE_DIRS ${CMAKE_CURRENT_BINARY_DIR})
