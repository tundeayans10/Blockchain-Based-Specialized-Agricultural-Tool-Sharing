;; Seasonal Allocation Contract
;; Manages sharing based on different harvest times

(define-data-var last-allocation-id uint u0)

(define-map allocations
  { id: uint }
  {
    equipment-id: uint,
    user: principal,
    start-date: uint,
    end-date: uint,
    status: (string-ascii 20) ;; "scheduled", "active", "completed"
  }
)

;; Request equipment allocation
(define-public (request-allocation
    (equipment-id uint)
    (start-date uint)
    (end-date uint)
  )
  (let
    (
      (new-id (+ (var-get last-allocation-id) u1))
    )
    (asserts! (< start-date end-date) (err u400))

    (var-set last-allocation-id new-id)

    (map-set allocations
      { id: new-id }
      {
        equipment-id: equipment-id,
        user: tx-sender,
        start-date: start-date,
        end-date: end-date,
        status: "scheduled"
      }
    )

    (ok new-id)
  )
)

;; Update allocation status
(define-public (update-allocation-status
    (allocation-id uint)
    (status (string-ascii 20))
  )
  (let
    (
      (allocation (unwrap! (map-get? allocations { id: allocation-id }) (err u404)))
    )
    (asserts! (is-eq tx-sender (get user allocation)) (err u403))

    (map-set allocations
      { id: allocation-id }
      (merge allocation { status: status })
    )

    (ok true)
  )
)

;; Get allocation details
(define-read-only (get-allocation (allocation-id uint))
  (map-get? allocations { id: allocation-id })
)

;; Get total allocation count
(define-read-only (get-allocation-count)
  (var-get last-allocation-id)
)
