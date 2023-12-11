//
//  FilterVC.swift
//  Everyday
//
//  Created by Михаил on 05.12.2023.
//

import UIKit
import HorizonCalendar

class FilterVC: UIViewController {

    var overlayView: UIView?
    let checkmarkImageView = UIImageView(image: UIImage(systemName: "checkmark"))
    var selectedFieldIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create a new view
        let overlay = UIView(frame: CGRect(x: (view.frame.width - 200) / 2, y: (view.frame.height - 200) / 2, width: 200, height: 200))
        overlay.backgroundColor = UIColor.systemBlue

        // Set the corner radius
        overlay.layer.cornerRadius = 10.0

        // Add the new view on top of the existing one
        view.addSubview(overlay)
        overlayView = overlay

        // Add a UIStackView for vertical fields
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.frame = overlay.bounds

        // Add 4 vertical fields
        for i in 1...3 {
            let button = UIButton(type: .system)
            button.setTitle("Field \(i)", for: .normal)
            button.addTarget(self, action: #selector(openDifferentView(_:)), for: .touchUpInside)
            button.tag = i // Set a unique tag for each button
            stackView.addArrangedSubview(button)
        }

        overlay.addSubview(stackView)

        // Add the system checkmark symbol to the right of the overlay
        checkmarkImageView.tintColor = UIColor.systemOrange
        checkmarkImageView.frame = CGRect(x: overlay.bounds.width - 30, y: 10, width: 20, height: 20)
        checkmarkImageView.isHidden = false
        overlay.addSubview(checkmarkImageView)

        // Add a gesture recognizer to handle taps outside the overlay
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideOverlay))
        view.addGestureRecognizer(tapGesture)

        // Update the checkmark position based on the selected field
        updateCheckmark()
    }

    @objc func hideOverlay() {
        dismiss(animated: true, completion: nil)
    }

    @objc func openDifferentView(_ sender: UIButton) {
        if let title = sender.titleLabel?.text {
            var destinationViewController: UIViewController?

            switch sender.tag {
            case 1:
                destinationViewController = SingleDaySelectionVC(monthsLayout: .vertical(
                                                                                    options: VerticalMonthsLayoutOptions(
                                                                                        pinDaysOfWeekToTop: false,
                                                                                        alwaysShowCompleteBoundaryMonths: false,
                                                                                        scrollsToFirstMonthOnStatusBarTap: false)))
            case 2:
                destinationViewController = CalendarVC(monthsLayout: .vertical(
                                                                        options: VerticalMonthsLayoutOptions(
                                                                            pinDaysOfWeekToTop: false,
                                                                            alwaysShowCompleteBoundaryMonths: false,
                                                                            scrollsToFirstMonthOnStatusBarTap: false)))
            case 3:
                destinationViewController = FewDaySelectionVC()
            default:
                break
            }
            
            if let destinationVC = destinationViewController {
                hideOverlay()

                // Закрыть текущий контроллер
                self.dismiss(animated: true) {
                    // Удалить предыдущий контроллер из иерархии контроллеров
                    self.willMove(toParent: nil)
                    self.view.removeFromSuperview()
                    self.removeFromParent()

                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let window = windowScene.windows.first,
                       let rootViewController = window.rootViewController {
                        // Заменить rootViewController новым
                        window.rootViewController = destinationVC

                        // Произвести анимацию перехода
                        UIView.transition(with: window,
                                          duration: 0.5,
                                          options: .transitionCrossDissolve,
                                          animations: nil,
                                          completion: nil)

                        // Обновить selectedFieldIndex и показать/скрыть галочку
                        self.selectedFieldIndex = sender.tag
                        self.updateCheckmark()
                    }
                }
            }
        }
    }

    func updateCheckmark() {
        for subview in overlayView?.subviews ?? [] {
            if let button = subview as? UIButton, button.tag == selectedFieldIndex {
                let checkmarkX = button.frame.origin.x + button.frame.width - 30
                checkmarkImageView.frame.origin.x = checkmarkX
                checkmarkImageView.isHidden = false
            } else if let button = subview as? UIButton {
                checkmarkImageView.isHidden = true
            }
        }
    }
}
