;; Maintenance Responsibility Contract
;; Tracks upkeep obligations among users

(define-data-var last-maintenance-id uint u0)

(define-map maintenance-records
  { id: uint }
  {
    equipment-id: uint,
    description: (string-ascii 200),
    responsible-user: principal,
    completed: bool,
    date: uint
  }
)

;; Record maintenance task
(define-public (record-maintenance
    (equipment-id uint)
    (description (string-ascii 200))
    (responsible-user principal)
  )
  (let
    (
      (new-id (+ (var-get last-maintenance-id) u1))
    )
    (var-set last-maintenance-id new-id)

    (map-set maintenance-records
      { id: new-id }
      {
        equipment-id: equipment-id,
        description: description,
        responsible-user: responsible-user,
        completed: false,
        date: block-height
      }
    )

    (ok new-id)
  )
)

;; Complete maintenance task
(define-public (complete-maintenance
    (maintenance-id uint)
  )
  (let
    (
      (record (unwrap! (map-get? maintenance-records { id: maintenance-id }) (err u404)))
    )
    (asserts! (is-eq tx-sender (get responsible-user record)) (err u403))

    (map-set maintenance-records
      { id: maintenance-id }
      (merge record {
        completed: true,
        date: block-height
      })
    )

    (ok true)
  )
)

;; Get maintenance record
(define-read-only (get-maintenance (maintenance-id uint))
  (map-get? maintenance-records { id: maintenance-id })
)

;; Get total maintenance count
(define-read-only (get-maintenance-count)
  (var-get last-maintenance-id)
)
